open Core

let _ =
  let collected = Engine.collect () in
  let () = Engine.dump collected in
  let parsed = Engine.parse collected in
  let analyzed = Engine.analyze parsed in
  Map.iteri analyzed ~f:(fun ~key ~data ->
      Printf.printf
        "analyzer: %s\n\
         ================================================================\n"
        key ;
      match data with
      | Ok v -> Printf.printf "%s\n" (Analyzer.Analyzer_result.show v)
      | Error e -> Printf.printf "%s\n" (Engine.show_notfound_list e) )
