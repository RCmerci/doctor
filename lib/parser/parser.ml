open Core

module type parser = sig
  type t [@@deriving show]

  type line = Collector.Line.t

  val name : string

  val required : string list

  val of_content : line list -> t

  val of_collected_map : Collector.collected_map -> t

  val attributes : t -> Attr.attrs
end

module ParsedMap = Map.Make (String)

let parsers =
  Map.of_alist_exn
    (module ParsedMap.Key)
    [ ( Var_log_message.Var_log_message.name
      , (module Var_log_message.Var_log_message : parser) )
    ; (Df.Df.name, (module Df.Df : parser))
    ; (Sar_load.Sar_load.name, (module Sar_load.Sar_load : parser)) ]

module Var_log_message : parser = Var_log_message.Var_log_message

module Df : parser = Df.Df

module Sar_load : parser = Sar_load.Sar_load

module Attr = Attr

type parsed_map = Attr.attrs ParsedMap.t
