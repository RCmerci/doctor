open Alcotest

let tests =
  [ ( "var/log/message"
    , `Quick
    , fun () ->
        let attrs =
          Testdata.var_log_message |> Collector.Var_log_message.of_string
          |> Collector.Var_log_message.parse ~parse_time:true
          |> snd |> Collector.Var_log_message.data
          |> Parser.Var_log_message.of_content
          |> Parser.Var_log_message.attributes
        in
        check bool "testdata.var_log_message" true (List.length attrs = 1) ) ]
