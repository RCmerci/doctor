open Alcotest

let tests =
  [ ( "var/log/message"
    , `Quick
    , fun () ->
        let attrs =
          Util.get_attrs Testdata.var_log_message
            (module Collector.Var_log_message)
            (module Parser.Var_log_message)
        in
        check bool (Parser.Attr.show_attrs attrs) true (List.length attrs = 1)
    ) ]
