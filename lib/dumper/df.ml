open Core
open Lwt

module Df = struct
  type t = Collector.Line.t list [@@deriving show]

  let required = Collector.Df.name

  let name = "df-dumper"

  let path = "df.txt"

  let of_string_list lines = List.map lines ~f:(fun l -> (None, l))

  let of_lines lines = lines

  let dump ?(path_prefix = Path.common_path_prefix) t =
    let%lwt () = return (try Unix.mkdir path_prefix with _ -> ()) in
    let logpath = Filename.concat path_prefix path in
    let%lwt out = Lwt_io.(open_file ~mode:Output logpath) in
    List.map t ~f:snd |> Lwt_stream.of_list |> Lwt_io.write_lines out
end
