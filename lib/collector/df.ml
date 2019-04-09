open Core

module Df = struct
  let name = "df-collector"

  type t = Line.t list

  let check_input_available () =
    None <> Shexp_process.(eval (find_executable "df"))

  let of_string s =
    List.filter_map (String.split_lines s) ~f:(fun l ->
        if String.is_empty l then None else Some (None, l) )

  let get_input ?(max_size = 10000L) _a _b : t =
    let _ = max_size in
    let all_output =
      let open Shexp_process in
      eval
        (set_env "LANG" "en_US"
           (capture_unit [Std_io.Stdout] (run "df" ["-h"])))
    in
    of_string all_output

  let data t = t

  let parse ?parse_time t =
    let _ = parse_time in
    (t, t)
end
