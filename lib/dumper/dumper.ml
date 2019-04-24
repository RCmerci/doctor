open Core
open Lwt

module type dumper = sig
  type t [@@deriving show]

  val path : string

  val name : string

  val required : string

  val of_lines : Collector.Line.t list -> t

  val dump : ?path_prefix:string -> Pp.t option -> t -> unit Lwt.t
end

module type name = sig
  val name : string

  val path : string
end

module Dumper_builder (M : Collector.collector) (Name : name) = struct
  type t = Collector.Line.t list [@@deriving show]

  let required = M.name

  let path = Name.path

  let name = Name.name

  let of_lines lines = lines

  let dump ?(path_prefix = Path.common_path_prefix) (mv : Pp.t option) t =
    let mvar_put =
      match mv with Some mv' -> Lwt_mvar.put mv' | None -> fun _ -> return ()
    in
    let%lwt _ = mvar_put {part= name; detail= "starting dump ..."} in
    let%lwt () = return (try Unix.mkdir path_prefix with _ -> ()) in
    let logpath = Filename.concat path_prefix path in
    let%lwt out = Lwt_io.(open_file ~mode:Output logpath) in
    let%lwt () =
      List.map t ~f:snd |> Lwt_stream.of_list |> Lwt_io.write_lines out
    in
    mvar_put {part= name; detail= "dump data done"}
end

module Var_log_message =
  Dumper_builder
    (Collector.Var_log_message)
    (struct
      let name = "var-log-message-dumper"

      let path = "var_log_message.txt"
    end)

module Df =
  Dumper_builder
    (Collector.Df)
    (struct
      let name = "df-dumper"

      let path = "df.txt"
    end)

module Sar_load =
  Dumper_builder
    (Collector.Sar_load)
    (struct
      let name = "sar-load-dumper"

      let path = "sar_load.txt"
    end)

module Sar_blkio =
  Dumper_builder
    (Collector.Sar_blkio)
    (struct
      let name = "sar-blkio-dumper"

      let path = "sar_blkio.txt"
    end)

let dumpers =
  Map.of_alist_exn
    (module String)
    [ (Var_log_message.name, (module Var_log_message : dumper))
    ; (Df.name, (module Df : dumper))
    ; (Sar_load.name, (module Sar_load : dumper))
    ; (Sar_blkio.name, (module Sar_blkio : dumper)) ]
