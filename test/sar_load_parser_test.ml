open Alcotest
open Core

let tests =
  [ ( "sar-load"
    , `Quick
    , fun () ->
        let attrs =
          Util.get_attrs Testdata.sar_load
            (module Collector.Sar_load)
            (module Parser.Sar_load)
        in
        check bool (Parser.Attr.show_attrs attrs) true (List.length attrs = 36)
    ) ]
