open Core

let around_attrlines ?(upsize = 5) ?(downsize = 5) index attrs =
  let curr_line =
    match List.nth attrs index with None -> [] | Some l -> [l]
  in
  let rec aux nextf index count r =
    if count = 0 then r
    else
      match List.nth attrs index with
      | None ->
          r
      | Some attr ->
          aux nextf (nextf index) (count - 1) (attr :: r)
  in
  let downlist = aux succ (index + 1) downsize [] |> List.rev in
  let uplist = aux pred (index - 1) upsize [] in
  uplist @ curr_line @ downlist

module Sar_load = struct
  let name = "sar-load-analyzer"

  let required = [Parser.Sar_load.name]

  let analyze (m : Parser.parsed_map) : Analyzer_result.t =
    assert (
      not (List.exists required ~f:(fun r -> not (Parser.ParsedMap.mem m r)))
    ) ;
    let attrs = Parser.ParsedMap.find_exn m Parser.Sar_load.name in
    let info =
      let only_care_sar_load attr =
        match attr with Parser.Attr.SAR_LOAD load -> load | _ -> assert false
      in
      List.filter_mapi attrs ~f:(fun index (attr, _) ->
          match attr with
          | Parser.Attr.SAR_LOAD sar_load ->
              if sar_load.ldavg_1 <= 40. then None
              else
                let around_attrs =
                  around_attrlines ~upsize:5 ~downsize:5 index attrs
                in
                if
                  List.exists around_attrs ~f:(fun (e, _) ->
                      let load = only_care_sar_load e in
                      load.ldavg_1 > sar_load.ldavg_1 )
                then None
                else
                  let detail_lines =
                    List.(
                      map around_attrs ~f:(fun (_, ls) -> map ls ~f:snd)
                      |> join)
                  in
                  Some (Parser.Attr.show_sar_load_line sar_load, detail_lines)
          | _ ->
              None )
    in
    {info; err= None}
end
