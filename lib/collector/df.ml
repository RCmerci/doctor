open Core
open Lwt

module Df = struct
  let name = "df-collector"

  type t = Line.t list

  let check_input_available (mv : Pp.t) =
    let y_or_n = None <> Shexp_process.(eval (find_executable "df")) in
    let%lwt _ =
      Lwt_mvar.put mv
        {part= name; detail= Printf.sprintf "check available %b" y_or_n}
    in
    return y_or_n

  let of_string s =
    List.filter_map
      ~f:(fun l -> if String.is_empty l then None else Some (None, l))
      (String.split_lines s)

  let get_input ?(max_size = 10000L) _a _b (mv : Pp.t) : t Lwt.t =
    let%lwt _ = Lwt_mvar.put mv {part= name; detail= "collecting data ..."} in
    let _ = max_size in
    let all_output =
      let open Shexp_process in
      eval
        (set_env "LANG" "en_US"
           (capture_unit [Std_io.Stdout] (run "df" ["-h"])))
    in
    let r = of_string all_output in
    let%lwt _ = Lwt_mvar.put mv {part= name; detail= "collecting data done"} in
    return r

  let data t = t

  let parse ?parse_time t =
    let _ = parse_time in
    return (t, t)
end
