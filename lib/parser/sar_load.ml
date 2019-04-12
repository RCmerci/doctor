open Core

(* e.g. "11:51:01 PM     14   568   0.16  0.09   0.13    0"
 output of 'sar -q' may contains title lines,
   return None if found. *)
let parse_sar_load_line l : Attr.sar_load_line option =
  if
    List.exists
      ["runq-sz"; "plist-sz"; "ldavg-1"; "ldavg-5"; "ldavg-15"; "blocked"]
      ~f:(fun e -> None <> String.substr_index l ~pattern:e)
  then None
  else
    let parts =
      List.filter (String.split l ~on:' ') ~f:(fun e -> not (String.is_empty e))
    in
    let nth_default parts nth =
      List.nth parts nth |> Option.value ~default:"-1"
    in
    Some
      { runq_sz= nth_default parts 2 |> Int.of_string
      ; plist_sz= nth_default parts 3 |> Int.of_string
      ; ldavg_1= nth_default parts 4 |> Float.of_string
      ; ldavg_5= nth_default parts 5 |> Float.of_string
      ; ldavg_15= nth_default parts 6 |> Float.of_string
      ; blocked= nth_default parts 7 |> Int.of_string }

module Sar_load = struct
  let name = "sar-load-parser"

  type line = Collector.Line.t

  type t = {attributes: Attr.attrs} [@@deriving show]

  let required = [Collector.Sar_load.name]

  let of_content (lines : line list) =
    let lines' = List.drop lines 1 in
    (* drop first title line *)
    let attributes =
      List.filter_map lines' ~f:(fun line ->
          let _, l = line in
          match parse_sar_load_line l with
          | None ->
              None (* skip *)
          | Some sar_load_line ->
              Some (Attr.SAR_LOAD sar_load_line, [line]) )
    in
    {attributes}

  let of_collected_map m =
    let open Collector in
    assert (CollectedMap.mem m Sar_load.name) ;
    let lines = CollectedMap.find_exn m Sar_load.name in
    of_content lines

  let attributes t = t.attributes
end
