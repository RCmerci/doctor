open Core

module Df = struct
  type t = Collector.Line.t list

  let required = Collector.Df.name

  let name = "df-dumper"

  let path = "df.txt"

  let of_string_list lines = List.map lines ~f:(fun l -> (None, l))

  let of_lines lines = lines

  let dump ?(path_prefix = Path.common_path_prefix) t =
    try Unix.mkdir path_prefix
    with _ ->
      () ;
      let logpath = Filename.concat path_prefix path in
      let out = Out_channel.create logpath in
      List.map t ~f:snd |> Out_channel.output_lines out
end
