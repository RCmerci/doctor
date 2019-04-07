open Core

let ( >>= ) = Option.( >>= )

let ( >>| ) = Option.( >>| )

(** [around ~duration ~uplines ~downlines ~exclusive_regexp index lines]
    [duration]: include line if its timestamp included in '[index] line's timestamp +- [duration]'
    [uplines]: max num of lines before [index] line
    [downlines]: max num of lines after [index] line
    [exclusive_regexp]: will stop add lines once found [exclusive_regexp]
*)
let around ?(duration = Time.Span.of_sec 3.) ?(uplines = 100)
    ?(downlines = 100) ?exclusive_regexp index (lines : Collector.Line.t list)
    =
  let center_time, _ =
    match List.nth lines index with Some l -> l | None -> (None, "")
  in
  let testf (l : Collector.Line.t) : Collector.Line.t option =
    ( match exclusive_regexp with
    | None -> Some l
    | Some r -> (
        let _, content = l in
        try Str.(search_forward (regexp r) content 0) |> fun _ -> None
        with _ -> Some l ) )
    >>= fun l ->
    match l with
    | None, _ -> Some l
    | Some time, _ ->
        center_time
        >>= fun center_time' ->
        if
          Time.(
            add center_time' duration >= time
            && sub center_time' duration <= time)
        then Some l
        else None
  in
  let rec aux up down upindex downindex =
    let upline = if upindex = -1 then None else List.nth lines upindex in
    let downline = if downindex = -1 then None else List.nth lines downindex in
    let upline' =
      upline >>= testf
      >>= fun l -> if upindex >= index - uplines then Some l else None
    in
    let downline' =
      downline >>= testf
      >>= fun l -> if downindex <= index + downlines then Some l else None
    in
    let next_up, next_upindex =
      match upline' with Some l -> (l :: up, upindex - 1) | None -> (up, -1)
    in
    let next_down, next_downindex =
      match downline' with
      | Some l -> (l :: down, downindex + 1)
      | None -> (down, -1)
    in
    if next_downindex = -1 && next_upindex = -1 then (up, List.rev down)
    else aux next_up next_down next_upindex next_downindex
  in
  let up, down = aux [] [] (index - 1) (index + 1) in
  match List.nth lines index >>| fun l -> List.append up (l :: down) with
  | Some r -> r
  | None -> []

let is_oom l : bool =
  String.substr_index l ~pattern:"out of memory" |> Option.is_some

(** [oom_info index lines]
    Returns (killed_cgroup path, killed_pid, killed_process_name, aroundlines) option *)
let oom_info index lines =
  let around_lines = around ~exclusive_regexp:"out of memory" index lines in
  let aux reg (_, content) =
    try Str.(search_forward (regexp reg) content 0) |> fun _ -> true
    with _ -> false
  in
  List.find around_lines ~f:(aux "Task in \\(.*?\\) killed")
  >>| (fun (_, content) -> Str.matched_group 1 content)
  >>= fun killed_cgroup ->
  List.find around_lines
    ~f:(aux "Killed process \\([0-9]+?\\) (\\(.*?\\)) total-vm")
  >>| (fun (_, content) ->
        (Str.matched_group 1 content, Str.matched_group 2 content) )
  >>| fun (killed_pid, killed_process_name) ->
  (killed_cgroup, killed_pid, killed_process_name, around_lines)

module Var_log_message = struct
  let name = "var-log-message-parser"

  let required = Collector.Var_log_message.name

  type line = Collector.Line.t [@@deriving show]

  type t = {origin: line list; attributes: (Attr.t * line list) list}
  [@@deriving show]

  let attr_funcs index lines =
    let attr =
      List.nth lines index
      >>= fun l ->
      (let _, content = l in
       if is_oom content then Some (Attr.OOM ("", "", "")) else Some Attr.OTHER)
      >>= fun kind ->
      match kind with
      | Attr.OOM _ ->
          oom_info index lines
          >>| fun (a, b, c, aroundlines) -> (Attr.OOM (a, b, c), aroundlines)
      | _ -> Some (Attr.OTHER, [l])
    in
    Option.value_exn attr

  let of_content (lines : line list) =
    let attributes =
      List.mapi lines ~f:(fun i _ -> attr_funcs i lines)
      |> List.filter ~f:(fun (attr, _) ->
             match attr with Attr.OTHER -> false | _ -> true )
    in
    {origin= lines; attributes}

  let attributes t = t.attributes
end
