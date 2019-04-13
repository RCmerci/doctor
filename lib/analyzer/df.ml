open Core

module Df = struct
  let name = "df-analyzer"

  let required = [Parser.Df.name]

  let analyze (m : Parser.parsed_map) : Analyzer_result.t =
    assert (
      not (List.exists required ~f:(fun r -> not (Parser.ParsedMap.mem m r)))
    ) ;
    let attrs = Parser.ParsedMap.find_exn m Parser.Df.name in
    let info =
      List.filter_map attrs ~f:(fun (attr, _) ->
          match attr with
          | Parser.Attr.DF_DISK_USAGE df when df.use > 80. ->
              Some (Parser.Attr.show_df_line df, [])
          | _ ->
              None )
    in
    {info; err= None}
end
