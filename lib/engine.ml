open Core
open Option.Let_syntax

let option_of_bool b = match b with true -> Some () | false -> None

let collect () =
  Map.map Collector.collectors ~f:(fun m ->
      let data =
        let module M = (val m : Collector.collector) in
        let%map () = option_of_bool (M.check_input_available ()) in
        let inputs = M.get_input None None in
        inputs |> M.parse |> fst
      in
      match data with Some v -> v | None -> [] )

let dump data =
  Map.map Dumper.dumpers ~f:(fun m ->
      let module M = (val m : Dumper.dumper) in
      let%map lines = Map.find data M.required in
      M.of_lines lines |> M.dump )
  |> ignore

let parse data =
  Map.map Parser.parsers ~f:(fun m ->
      let attrs =
        let module M = (val m : Parser.parser) in
        let%map lines = Map.find data M.required in
        M.of_content lines |> M.attributes
      in
      match attrs with Some v -> v | None -> [] )

type notfound_list = string list [@@deriving show]

let analyze data =
  Map.map Analyzer.analyzers ~f:(fun m ->
      let module M = (val m : Analyzer.analyzer) in
      let (notfound : notfound_list) =
        List.filter M.required ~f:(fun r -> not (Map.mem data r))
      in
      match notfound with [] -> Ok (M.analyze data) | _ -> Error notfound )
