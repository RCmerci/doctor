let get_attrs testdata (c : (module Collector.collector))
    (p : (module Parser.parser)) : Parser.Attr.attrs =
  let module C = (val c) in
  let module P = (val p) in
  testdata |> C.of_string |> C.parse ~parse_time:true |> snd |> C.data
  |> P.of_content |> P.attributes
