open Core

module type parser = sig
  type t [@@deriving show]

  type line = Collector.Line.t

  val name : string

  val required : string

  val of_content : line list -> t

  val attributes : t -> Attr.attrs
end

module ParsedMap = Map.Make (String)

let parsers =
  Map.of_alist_exn
    (module ParsedMap.Key)
    [ ( Var_log_message.Var_log_message.name
      , (module Var_log_message.Var_log_message : parser) ) ]

module Var_log_message : parser = Var_log_message.Var_log_message

module Attr = Attr

type parsed_map = Attr.attrs ParsedMap.t
