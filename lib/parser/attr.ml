type t =
  (* (killed_cgroup_path * killed_pid * killed_process_name) *)
  | OOM of (string * string * string)
  | OTHER
[@@deriving show]

type attrs = (t * Collector.Line.t list) list [@@deriving show]
