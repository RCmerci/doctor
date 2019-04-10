open Core

let timepair (starttime : Time.t option) (endtime : Time.t option) =
  let open Time in
  match (starttime, endtime) with
  | None, None ->
      (sub (now ()) (Span.of_hr 10.), now ())
  | Some s, None ->
      (s, add s (Span.of_hr 10.))
  | None, Some e ->
      (sub e (Span.of_hr 10.), e)
  | Some s, Some e when s >= e ->
      (* when start >= end, use (start, start+ 10 hour) *)
      (s, add s (Span.of_hr 10.))
  | Some s, Some e ->
      (s, e)

let current_year =
  Time.now ()
  |> Time.to_date ~zone:(Time.Zone.of_utc_offset ~hours:8)
  |> Date.year

let read_lines filepath max_size =
  let open Lwt_io in
  with_file ~mode:Input filepath (fun f ->
      let%lwt length = length f in
      let pos = if length > max_size then Int64.(length - max_size) else 0L in
      let%lwt () = set_position f pos in
      (* drop first line, because it is partial *)
      let%lwt _ = read_line f in
      Lwt_stream.to_list (read_lines f) )
