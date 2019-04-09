open Core

module Var_log_message = struct
  let name = "var-log-message-analyzer"

  let required = ["var-log-message-parser"]

  let analyze_aux (parsed : Parser.parsed_map) =
    let messages = Parser.ParsedMap.find_exn parsed "var-log-message-parser" in
    let info =
      List.filter_map messages ~f:(fun (attr, _lines) ->
          match attr with
          | Parser.Attr.OOM
              (time, killed_cgroup_path, killed_pid, killed_process_name) ->
              Some
                (Printf.sprintf "[%s] OOM pid: %s, process: %s, cgroup: %s"
                   (Time.format time "%m-%d %T"
                      ~zone:(Time.Zone.of_utc_offset ~hours:8))
                   killed_pid killed_process_name killed_cgroup_path)
          | _ ->
              None )
    in
    info

  let analyze parsed : Analyzer_result.t =
    assert (
      not
        (List.exists required ~f:(fun r -> not (Parser.ParsedMap.mem parsed r)))
    ) ;
    {info= analyze_aux parsed; err= None}
end
