open Core

let main_route mv =
  let%lwt collected = Engine.collect mv in
  let%lwt () = Engine.dump collected mv in
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

let _ =
  let mv = Lwt_mvar.create_empty () in
  Lwt.async (fun () -> Pp.print_thread mv (Time.now ())) ;
  main_route mv |> Lwt_main.run
