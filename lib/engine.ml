open Core

let option_of_bool b = match b with true -> Some () | false -> None

type notfound_list = string list [@@deriving show]

let collect () =
  let open Lwt in
  Map.to_alist Collector.collectors
  |> Lwt_list.filter_map_p (fun (name, m) ->
         let module M = (val m : Collector.collector) in
         let%lwt available = M.check_input_available () in
         match available with
         | true ->
             M.get_input None None >>= M.parse >|= fst >|= Tuple2.create name
             >|= Option.some
         | false ->
             return None )
  >|= Map.of_alist_exn (module Collector.CollectedMap.Key)

let dump data =
  let open Lwt in
  Map.to_alist Dumper.dumpers
  |> Lwt_list.map_p (fun (_name, m) ->
         let module M = (val m : Dumper.dumper) in
         match Option.(Map.find data M.required >>| M.of_lines) with
         | Some t ->
             M.dump t
         | None ->
             return_unit )
  >|= ignore

let parse data =
  Map.filter_map Parser.parsers ~f:(fun m ->
      let module M = (val m : Parser.parser) in
      let (notfound : notfound_list) =
        List.filter M.required ~f:(fun r -> not (Map.mem data r))
      in
      match notfound with
      | [] ->
          Some (M.of_collected_map data |> M.attributes)
      | _ ->
          None )

let analyze data =
  Map.map Analyzer.analyzers ~f:(fun m ->
      let module M = (val m : Analyzer.analyzer) in
      let (notfound : notfound_list) =
        List.filter M.required ~f:(fun r -> not (Map.mem data r))
      in
      match notfound with [] -> Ok (M.analyze data) | _ -> Error notfound )
