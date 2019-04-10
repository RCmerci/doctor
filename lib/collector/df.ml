open Core
open Lwt

module Df = struct
  let name = "df-collector"

  type t = Line.t list

  let check_input_available () =
    return (None <> Shexp_process.(eval (find_executable "df")))

  let of_string s =
    List.filter_map
      ~f:(fun l -> if String.is_empty l then None else Some (None, l))
      (String.split_lines s)

  let get_input ?(max_size = 10000L) _a _b : t Lwt.t =
    let _ = max_size in
    let all_output =
      let open Shexp_process in
      eval
        (set_env "LANG" "en_US"
           (capture_unit [Std_io.Stdout] (run "df" ["-h"])))
    in
    return (of_string all_output)

  let data t = t

  let parse ?parse_time t =
    let _ = parse_time in
    return (t, t)
end
