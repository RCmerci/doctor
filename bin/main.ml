open Core

let main_route =
  let%lwt collected = Engine.collect () in
  let%lwt () = Engine.dump collected in
  let parsed = Engine.parse collected in
  let analyzed = Engine.analyze parsed in
  let r =
    Map.iteri analyzed ~f:(fun ~key ~data ->
        Printf.printf
          "analyzer: %s\n\
           ================================================================\n"
          key ;
        match data with
        | Ok v ->
            Printf.printf "%s\n" (Analyzer.Analyzer_result.show v)
        | Error e ->
            Printf.printf "%s\n" (Engine.show_notfound_list e) )
  in
  Lwt.return r

let _ = main_route |> Lwt_main.run
