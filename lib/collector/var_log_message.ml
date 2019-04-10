open Core
open Lwt

let parse_var_log_message_time (s : string) : Time.t option Lwt.t =
  ( try
      Some
        (Time.parse
           (Printf.sprintf "%d %s" Util.current_year s)
           ~fmt:"%Y %b %d %T"
           ~zone:(Time.Zone.of_utc_offset ~hours:8))
    with _ -> None )
  |> return

module Var_log_message = struct
  let path = "/var/log/messages"

  let name = "var-log-message-collector"

  type t = {parsed_time: bool; data: Line.t list}

  let check_input_available () = return (Sys.file_exists_exn path)

  (* ignore 'starttime' 'endtime', return all var/log/message content *)
  let get_input ?(max_size = 10240000L) (_ : Time.t option) (_ : Time.t option)
      : t Lwt.t =
    let%lwt data = Util.read_lines path max_size in
    let data' = List.map data ~f:(fun l -> (None, l)) in
    return {parsed_time= false; data= data'}

  let of_string s : t =
    { parsed_time= false
    ; data= List.map (String.split_lines s) ~f:(fun l -> (None, l)) }

  let data t = t.data

  let parse ?(parse_time = true) t =
    match t.parsed_time with
    | true ->
        return (t.data, t)
    | false when not parse_time ->
        return (t.data, t)
    | false ->
        let%lwt data =
          Lwt_list.map_p
            (fun (_, l) ->
              let%lwt time = parse_var_log_message_time l in
              return (time, l) )
            t.data
        in
        return (data, {parsed_time= true; data})
end
