open Core

module type analyzer = sig
  val name : string

  val required : string list

  val analyze : Parser.parsed_map -> Analyzer_result.t
end

let analyzers =
  Map.of_alist_exn
    (module String)
    [ ( Var_log_message.Var_log_message.name
      , (module Var_log_message.Var_log_message : analyzer) ) ]

module Analyzer_result = Analyzer_result