open Alcotest
open Core

let tests =
  [ ( "df"
    , `Quick
    , fun () ->
        let attrs =
          Util.get_attrs Testdata.df (module Collector.Df) (module Parser.Df)
        in
        check bool (Parser.Attr.show_attrs attrs) true (List.length attrs = 8)
    ) ]
