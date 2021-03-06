open Core
module Line = Line

module type collector = sig
  type t

  val name : string

  val check_input_available : Pp.t -> bool Lwt.t
  (** [check_input_available ()] check input method available*)

  val get_input :
    ?max_size:int64 -> Time.t option -> Time.t option -> Pp.t -> t Lwt.t
  (** [get_input ~max_size start end]
      [max_size]: max char num *)

  val of_string : string -> t

  val data : t -> Line.t list

  val parse : ?parse_time:bool -> Pp.t option -> t -> (Line.t list * t) Lwt.t
  (** [parse ?parse_time t] parse collected content *)
end

module CollectedMap = Map.Make (String)

let collectors =
  Map.of_alist_exn
    (module CollectedMap.Key)
    [ ( Var_log_message.Var_log_message.name
      , (module Var_log_message.Var_log_message : collector) )
    ; (Df.Df.name, (module Df.Df : collector))
    ; (Sar_load.Sar_load.name, (module Sar_load.Sar_load : collector))
    ; (Sar_blkio.Sar_blkio.name, (module Sar_blkio.Sar_blkio : collector)) ]

module Var_log_message : collector = Var_log_message.Var_log_message

module Df : collector = Df.Df

module Sar_load : collector = Sar_load.Sar_load

module Sar_blkio : collector = Sar_blkio.Sar_blkio

type collected_map = Line.t list CollectedMap.t
