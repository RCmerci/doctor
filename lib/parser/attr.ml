open Core

type df_line =
  { filesystem: string
  ; size: string
  ; used: string
  ; avail: string
  ; use: float (* pcent *)
  ; mount_on: string }
[@@deriving show]

type t =
  (* (time * killed_cgroup_path * killed_pid * killed_process_name) *)
  | OOM of (Time.t * string * string * string)
  | DF_DISK_USAGE of df_line
  | OTHER
[@@deriving show]

type attrs = (t * Collector.Line.t list) list [@@deriving show]
