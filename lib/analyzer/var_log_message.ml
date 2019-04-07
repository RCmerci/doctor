open Core
open Result.Let_syntax

module Var_log_message = struct
  let name = "var-log-message-analyzer"

  let required = ["var-log-message-parser"]

  let analyze_aux (parsed : Parser.parsed_map) =
    let%map messages =
      Parser.ParsedMap.find parsed "var-log-message-parser"
      |> Result.of_option ~error:"not found var-log-message's parsed result"
    in
    let info =
      List.map messages ~f:(fun (attr, _lines) ->
          match attr with
          | Parser.Attr.OOM
              (killed_cgroup_path, killed_pid, killed_process_name) ->
              Printf.sprintf "OOM pid: %s, process: %s, cgroup: %s" killed_pid
                killed_process_name killed_cgroup_path
          | Parser.Attr.OTHER -> "OTHER" )
    in
    info

  let analyze parsed : Analyzer_result.t =
    match analyze_aux parsed with
    | Ok info -> {info; err= None}
    | Error e -> {info= []; err= Some e}
end
