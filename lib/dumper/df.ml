open Core
open Lwt

module Df = struct
  type t = Collector.Line.t list [@@deriving show]

  let required = Collector.Df.name

  let name = "df-dumper"

  let path = "df.txt"

  let of_string_list lines = List.map lines ~f:(fun l -> (None, l))

  let of_lines lines = lines

  let dump ?(path_prefix = Path.common_path_prefix) (mv : Pp.t) t =
    let%lwt _ = Lwt_mvar.put mv {part= name; detail= "starting dump ..."} in
    let%lwt () = return (try Unix.mkdir path_prefix with _ -> ()) in
    let logpath = Filename.concat path_prefix path in
    let%lwt out = Lwt_io.(open_file ~mode:Output logpath) in
    let%lwt () =
      List.map t ~f:snd |> Lwt_stream.of_list |> Lwt_io.write_lines out
    in
    Lwt_mvar.put mv {part= name; detail= "dump data done"}
end
