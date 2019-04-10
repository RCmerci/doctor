open Core

module type dumper = sig
  type t [@@deriving show]

  val path : string

  val name : string

  val required : string

  val of_string_list : string list -> t

  val of_lines : Collector.Line.t list -> t

  val dump : ?path_prefix:string -> t -> unit Lwt.t
end

let dumpers =
  Map.of_alist_exn
    (module String)
    [ ( Var_log_message.Var_log_message.name
      , (module Var_log_message.Var_log_message : dumper) )
    ; (Df.Df.name, (module Df.Df : dumper)) ]

module Var_log_message : dumper = Var_log_message.Var_log_message

module Df : dumper = Df.Df
