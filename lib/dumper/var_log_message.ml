open Core
open Lwt

module Var_log_message = struct
  type t = Collector.Line.t list [@@deriving show]

  let required = Collector.Var_log_message.name

  let name = "var-log-message-dumper"

  let path = "var_log_message.txt"

  let of_lines lines = lines

  let dump ?(path_prefix = Path.common_path_prefix) (mv : Pp.t option) t =
    let mvar_put =
      match mv with Some mv' -> Lwt_mvar.put mv' | None -> fun _ -> return ()
    in
    let%lwt _ = mvar_put {part= name; detail= "starting dump ..."} in
    let%lwt () = Lwt.return (try Unix.mkdir_p path_prefix with _ -> ()) in
    let logpath = Filename.concat path_prefix path in
    let%lwt out = Lwt_io.(open_file ~mode:Output logpath) in
    let%lwt () =
      List.map t ~f:snd |> Lwt_stream.of_list |> Lwt_io.write_lines out
    in
    mvar_put {part= name; detail= "dump data done "}
end
