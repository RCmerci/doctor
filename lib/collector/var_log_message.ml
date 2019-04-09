open Core

let parse_var_log_message_time (s : string) : Time.t option =
  try
    Some
      (Time.parse
         (Printf.sprintf "%d %s" Util.current_year s)
         ~fmt:"%Y %b %d %T"
         ~zone:(Time.Zone.of_utc_offset ~hours:8))
  with _ -> None

module Var_log_message = struct
  let path = "/var/log/messages"

  let name = "var-log-message-collector"

  type t = {parsed_time: bool; data: Line.t list}

  let check_input_available () = Sys.file_exists_exn path

  (* ignore 'starttime' 'endtime', return all var/log/message content *)
  let get_input ?(max_size = 100000L) (_ : Time.t option) (_ : Time.t option) :
      t =
    let data =
      Util.read_lines path max_size |> List.map ~f:(fun l -> (None, l))
    in
    {parsed_time= false; data}

  let of_string s : t =
    { parsed_time= false
    ; data= List.map (String.split_lines s) ~f:(fun l -> (None, l)) }

  let data t = t.data

  let parse ?(parse_time = true) t =
    match t.parsed_time with
    | true -> (t.data, t)
    | false when not parse_time -> (t.data, t)
    | false ->
        let data =
          List.map ~f:(fun (_, l) -> (parse_var_log_message_time l, l)) t.data
        in
        (data, {parsed_time= true; data})
end
