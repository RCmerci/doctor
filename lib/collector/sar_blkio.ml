open Core
open Lwt

module Sar_blkio = struct
  let name = "sar-blkio-collector"

  type t = {parsed_time: bool; data: Line.t list}

  let check_input_available (mv : Pp.t) =
    let y_or_n = None <> Shexp_process.(eval (find_executable "sar")) in
    let%lwt _ = Pp.log mv name (Printf.sprintf "check available %b" y_or_n) in
    return y_or_n

  let of_string s =
    let data =
      List.filter_map
        ~f:(fun l -> if String.is_empty l then None else Some (None, l))
        (String.split_lines s)
    in
    {parsed_time= false; data}

  let get_input ?(max_size = 10000L) starttime endtime mv =
    let%lwt _ = Pp.log mv name "collecting data ..." in
    let _ = max_size in
    let format_time time =
      Time.(format time "%T" ~zone:(Zone.of_utc_offset ~hours:8))
    in
    let cmd_args =
      let s, e = Util.timepair starttime endtime in
      ["-d"; "-s"; format_time s; "-e"; format_time e]
    in
    let output =
      let open Shexp_process in
      eval
        (set_env "LANG" "en_US"
           (capture_unit [Std_io.Stdout] (run "sar" cmd_args)))
    in
    let r = of_string output in
    let%lwt _ = Pp.log mv name "collecting data done" in
    return r

  let data t = t.data

  let parse ?(parse_time = true) (mv : Pp.t option) t =
    let log =
      match mv with Some mv' -> Pp.log mv' | None -> fun _ _ -> return ()
    in
    let%lwt _ = log name "parsing data timestamp ..." in
    let%lwt r =
      match t.parsed_time with
      | true ->
          return (t.data, t)
      | false when not parse_time ->
          return (t.data, t)
      | false ->
          let data =
            List.map t.data ~f:(fun (_, l) ->
                let time = Util.parse_sar_time l in
                (time, l) )
          in
          return (data, {parsed_time= true; data})
    in
    let%lwt _ = log name "parse data timestamp done" in
    return r
end
