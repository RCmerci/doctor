open Core

module Var_log_message = struct
  type t = Collector.Line.t list [@@deriving show]

  let required = Collector.Var_log_message.name

  let name = "var-log-message-dumper"

  let path = "var_log_message.txt"

  let of_string_list lines = List.map lines ~f:(fun l -> (None, l))

  let of_lines lines = lines

  let dump ?(path_prefix = Path.common_path_prefix) t =
    let%lwt () = Lwt.return (try Unix.mkdir_p path_prefix with _ -> ()) in
    let logpath = Filename.concat path_prefix path in
    let%lwt out = Lwt_io.(open_file ~mode:Output logpath) in
    List.map t ~f:snd |> Lwt_stream.of_list |> Lwt_io.write_lines out
end
