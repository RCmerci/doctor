open Core
open Lwt

type state = {part: string; detail: string}

type t = state Lwt_mvar.t

let rec print_thread (mv : t) (start_time : Time.t) =
  let%lwt newstate = Lwt_mvar.take mv in
  let%lwt _ =
    Lwt_io.printlf "[\027[32m%-30s\027[0m] [%5s] %s" newstate.part
      Time.(diff (now ()) start_time |> Span.to_short_string)
      newstate.detail
    >>= fun _ -> Lwt_io.(flush stdout)
  in
  print_thread mv start_time

let log (mv : t) header detail = Lwt_mvar.put mv {part= header; detail}
