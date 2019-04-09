open Core

(* e.g.
   /dev/xvda1       40G   26G   12G   69% / *)
let parse_df_line line : Attr.df_line =
  let parts =
    List.filter
      ~f:(fun e -> not (String.is_empty e))
      (String.split_on_chars ~on:[' '] line)
  in
  let nth_default parts nth =
    List.nth parts nth |> Option.value ~default:"Unknown"
  in
  { filesystem= nth_default parts 0
  ; size= nth_default parts 1
  ; used= nth_default parts 2
  ; avail= nth_default parts 3
  ; use=
      Option.(
        value ~default:(-1.)
          (Option.map (List.nth parts 4) ~f:(fun pcent ->
               String.(slice pcent 0 (length pcent - 1)) |> Float.of_string )))
  ; mount_on= nth_default parts 5 }

module Df = struct
  let name = "df-parser"

  type line = Collector.Line.t [@@deriving show]

  type t = {origin: line list; attributes: Attr.attrs} [@@deriving show]

  let required = [Collector.Df.name]

  let of_content (lines : line list) =
    let lines' = List.drop lines 1 in
    let attributes : Attr.attrs =
      List.map lines' ~f:(fun line ->
          let _, l = line in
          (Attr.DF_DISK_USAGE (parse_df_line l), [line]) )
    in
    {origin= lines; attributes}

  let of_collected_map m =
    assert (Collector.(CollectedMap.mem m Df.name)) ;
    let lines = Collector.(CollectedMap.find_exn m Df.name) in
    of_content lines

  let attributes t = t.attributes
end
