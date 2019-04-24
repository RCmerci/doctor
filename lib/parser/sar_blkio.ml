open Core

(* 11:24:01 PM       DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
 * 11:25:01 PM  dev253-0     15.38      0.00    251.92     16.38      0.23     14.85      0.42      0.64 *)
let parse_sar_blkio_line l : Attr.sar_blkio_line option =
  if
    List.exists
      [ "DEV"
      ; "tps"
      ; "rd_sec/s"
      ; "wr_sec/s"
      ; "avgrq-sz"
      ; "avgqu-sz"
      ; "await"
      ; "svctm"
      ; "%util" ] ~f:(fun e -> None <> String.substr_index l ~pattern:e)
  then None
  else
    let parts =
      List.filter (String.split l ~on:' ') ~f:(fun e -> not (String.is_empty e))
    in
    let nth_default parts nth =
      List.nth parts nth |> Option.value ~default:"-1"
    in
    Some
      { dev= nth_default parts 2
      ; tps= nth_default parts 3 |> Float.of_string
      ; rd_sec= nth_default parts 4 |> Float.of_string
      ; wr_sec= nth_default parts 5 |> Float.of_string
      ; avgrq_sz= nth_default parts 6 |> Float.of_string
      ; avgqu_sz= nth_default parts 7 |> Float.of_string
      ; await= nth_default parts 8 |> Float.of_string
      ; svctm= nth_default parts 9 |> Float.of_string
      ; util= nth_default parts 10 |> Float.of_string }

module Sar_blkio = struct
  let name = "sar-blkio-parser"

  type line = Collector.Line.t

  type t = {attributes: Attr.attrs} [@@deriving show]

  let required = [Collector.Sar_blkio.name]

  let of_content (lines : line list) =
    (* drop 1st title line *)
    let lines' = List.drop lines 1 in
    let attributes =
      List.filter_map lines' ~f:(fun line ->
          let time, l = line in
          match time with
          | None ->
              None
          | Some _ ->
              Option.(
                parse_sar_blkio_line l
                >>| fun sar_blkio_line ->
                (Attr.SAR_BLKIO sar_blkio_line, [line])) )
    in
    {attributes}

  let of_collected_map m =
    let open Collector in
    assert (CollectedMap.mem m Sar_blkio.name) ;
    let lines = CollectedMap.find_exn m Sar_blkio.name in
    of_content lines

  let attributes t = t.attributes
end
