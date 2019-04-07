open Alcotest
open Core

let tests =
  [ ( "var/log/message"
    , `Quick
    , fun () ->
        let _ = try Sys.remove "./var_log_message.txt" with _ -> () in
        let _ =
          Testdata.var_log_message |> Collector.Var_log_message.of_string
          |> Collector.Var_log_message.data |> Dumper.Var_log_message.of_lines
          |> Dumper.Var_log_message.dump ~path_prefix:"."
        in
        check bool "./var_log_message.txt not exists" true
          (Sys.file_exists_exn "./var_log_message.txt") ) ]
