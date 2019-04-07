open Core

let timepair (starttime : Time.t option) (endtime : Time.t option) =
  let open Time in
  match (starttime, endtime) with
  | None, None -> (sub (now ()) (Span.of_hr 10.), now ())
  | Some s, None -> (s, add s (Span.of_hr 10.))
  | None, Some e -> (sub e (Span.of_hr 10.), e)
  | Some s, Some e when s >= e ->
      (* when start >= end, use (start, start+ 10 hour) *)
      (s, add s (Span.of_hr 10.))
  | Some s, Some e -> (s, e)

let current_year =
  Time.now ()
  |> Time.to_date ~zone:(Time.Zone.of_utc_offset ~hours:8)
  |> Date.year

let read_lines filepath max_size =
  In_channel.with_file filepath ~f:(fun file ->
      let length = In_channel.length file in
      let pos = if length > max_size then Int64.(length - max_size) else 0L in
      let () = In_channel.seek file pos in
      (* drop first line, because it is partial *)
      let _ = In_channel.input_line file in
      In_channel.input_lines file )
