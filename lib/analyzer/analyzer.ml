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
      , (module Var_log_message.Var_log_message : analyzer) )
    ; (Df.Df.name, (module Df.Df : analyzer))
    ; (Sar_load.Sar_load.name, (module Sar_load.Sar_load : analyzer)) ]

module Analyzer_result = Analyzer_result
