open Core

type df_line =
  { filesystem: string
  ; size: string
  ; used: string
  ; avail: string
  ; use: float (* pcent *)
  ; mount_on: string }
[@@deriving show]

(* sar -q *)
type sar_load_line =
  { runq_sz: int
  ; plist_sz: int
  ; ldavg_1: float
  ; ldavg_5: float
  ; ldavg_15: float
  ; blocked: int }
[@@deriving show]

(* sar -d
   11:24:01 PM       DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
 * 11:25:01 PM  dev253-0     15.38      0.00    251.92     16.38      0.23     14.85      0.42      0.64 *)
type sar_blkio_line =
  { dev: string
  ; tps: float
  ; rd_sec: float
  ; wr_sec: float
  ; avgrq_sz: float
  ; avgqu_sz: float
  ; await: float
  ; svctm: float
  ; util: float }
[@@deriving show]

type t =
  (* (time * killed_cgroup_path * killed_pid * killed_process_name) *)
  | OOM of (Time.t * string * string * string)
  | DF_DISK_USAGE of df_line
  | SAR_LOAD of sar_load_line
  | SAR_BLKIO of sar_blkio_line
  | OTHER
[@@deriving show]

type attrs = (t * Collector.Line.t list) list [@@deriving show]
