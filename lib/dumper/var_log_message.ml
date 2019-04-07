open Core

module Var_log_message = struct
  type t = Collector.Line.t list

  let required = Collector.Var_log_message.name

  let name = "var-log-message-dumper"

  let path = "var_log_message.txt"

  let of_string_list lines = List.map lines ~f:(fun l -> (None, l))

  let of_lines lines = lines

  let dump ?(path_prefix = Path.common_path_prefix) t =
    List.map t ~f:snd
    |> Out_channel.write_lines (Filename.concat path_prefix path)
end
