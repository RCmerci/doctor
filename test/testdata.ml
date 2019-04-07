let var_log_message =
  String.trim
    "Apr  2 18:05:05 ucuducdc-dev-public-010168000078 haproxy[10870]: \
     42.120.75.128:45272 [02/Apr/2019:10:05:05.563] marathon_http_in \
     iiiiii_ui_10038/10_168_0_101_9_0_15_14_80 0/0/1/1/2 401 335 - - ---- \
     26/25/18/18/0 0/0 \"GET /api/pipelines/ws/info?t=1554199505557 HTTP/1.1\"\n\
     Apr  2 18:05:05 ucuducdc-dev-public-010168000078 haproxy[10870]: \
     42.120.75.151:55866 [02/Apr/2019:10:05:05.688] marathon_http_in \
     iiiiii_ui_10038/10_168_0_101_9_0_15_14_80 0/0/0/1/1 401 335 - - ---- \
     26/25/19/19/0 0/0 \"GET /api/o11/ws/info?t=1554199505682 HTTP/1.1\"\n\
     Apr  2 18:05:05 ucuducdc-dev-public-010168000078 haproxy[10870]: \
     42.120.75.151:62820 [02/Apr/2019:10:05:05.687] marathon_http_in \
     iiiiii_ui_10038/10_168_0_101_9_0_15_14_80 0/0/1/1/2 401 335 - - ---- \
     26/25/18/18/0 0/0 \"GET /api/pipelines/ws/info?t=1554199505681 HTTP/1.1\"\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 mesos-agent: I0402 \
     18:05:06.307943 19389 http.cpp:1117] HTTP POST for /slave(1)/api/v1 from \
     10.168.0.78:39675 with User-Agent='navstar@10.168.0.78 (pid 19211)'\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 mesos-agent: I0402 \
     18:05:06.308109 19389 http.cpp:1860] Processing GET_STATE call\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 mesos-agent: I0402 \
     18:05:06.381827 19388 http.cpp:1117] HTTP POST for /slave(1)/api/v1 from \
     10.168.0.78:39675 with User-Agent='navstar@10.168.0.78 (pid 19211)'\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 mesos-agent: I0402 \
     18:05:06.381975 19388 http.cpp:1799] Processing GET_AGENT call\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: filebeat \
     invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: filebeat \
     cpuset=93bc1e65f9c3b0a466f79e7d807afb4b930302545847716c2c5cddf15359ce21 \
     mems_allowed=0\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: CPU: 2 PID: \
     16283 Comm: filebeat Tainted: G               ------------ T \
     3.10.0-693.2.2.el7.x86_64 #1\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: Hardware name: \
     Alibaba Cloud Alibaba Cloud ECS, BIOS 99a222b 04/01/2014\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     ffff88021e680000 0000000018fe5bc6 ffff88024f6cbc90 ffffffff816a3db1\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     ffff88024f6cbd20 ffffffff8169f1a6 ffff88025b2ee980 0000000000000001\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     0000000000000000 ffff88042cdf4350 ffff88024f6cbcd0 0000000000000046\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: Call Trace:\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff816a3db1>] dump_stack+0x19/0x1b\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff8169f1a6>] dump_header+0x90/0x229\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff81185ee6>] ? find_lock_task_mm+0x56/0xc0\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff81186394>] oom_kill_process+0x254/0x3d0\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff811f52a6>] mem_cgroup_oom_synchronize+0x546/0x570\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff811f4720>] ? mem_cgroup_charge_common+0xc0/0xc0\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff81186c24>] pagefault_out_of_memory+0x14/0x90\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff8169d56e>] mm_fault_error+0x68/0x12b\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff816b0231>] __do_page_fault+0x391/0x450\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff816b03d6>] trace_do_page_fault+0x56/0x150\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff816afa6a>] do_async_page_fault+0x1a/0xd0\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: \
     [<ffffffff816ac578>] async_page_fault+0x28/0x30\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: Task in \
     /docker/93bc1e65f9c3b0a466f79e7d807afb4b930302545847716c2c5cddf15359ce21 \
     killed as a result of limit of \
     /docker/93bc1e65f9c3b0a466f79e7d807afb4b930302545847716c2c5cddf15359ce21\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: memory: usage \
     131072kB, limit 131072kB, failcnt 704\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: memory+swap: \
     usage 131072kB, limit 262144kB, failcnt 0\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: kmem: usage \
     0kB, limit 9007199254740988kB, failcnt 0\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: Memory cgroup \
     stats for \
     /docker/93bc1e65f9c3b0a466f79e7d807afb4b930302545847716c2c5cddf15359ce21: \
     cache:0KB rss:131072KB rss_huge:0KB mapped_file:0KB swap:0KB \
     inactive_anon:0KB active_anon:131028KB inactive_file:0KB active_file:0KB \
     unevictable:0KB\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: [ pid ]   uid  \
     tgid total_vm      rss nr_ptes swapents oom_score_adj name\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: [16169]     0 \
     16169   133307    35056     107        0             0 filebeat\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: Memory cgroup \
     out of memory: Kill process 16283 (filebeat) score 1073 or sacrifice \
     child\n\
     Apr  2 18:05:06 ucuducdc-dev-public-010168000078 kernel: Killed process \
     16169 (filebeat) total-vm:533228kB, anon-rss:129904kB, file-rss:10320kB, \
     shmem-rss:0kB\n\
     Apr  2 18:05:07 ucuducdc-dev-public-010168000078 dockerd: \
     time=\"2019-04-02T18:05:07.178125973+08:00\" level=info msg=\"shim \
     reaped\" \
     id=93bc1e65f9c3b0a466f79e7d807afb4b930302545847716c2c5cddf15359ce21\n\
     Apr  2 18:05:07 ucuducdc-dev-public-010168000078 dockerd: \
     time=\"2019-04-02T18:05:07.187990192+08:00\" level=info msg=\"ignoring \
     event\" module=libcontainerd namespace=moby topic=/tasks/delete \
     type=\"*events.TaskDelete\"\n\
     Apr  2 18:05:07 ucuducdc-dev-public-010168000078 kernel: d-dcos: port \
     1(veth78e9c4c) entered disabled state\n\
     Apr  2 18:05:07 ucuducdc-dev-public-010168000078 kernel: d-dcos: port \
     1(veth78e9c4c) entered disabled state\n\
     Apr  2 18:05:07 ucuducdc-dev-public-010168000078 kernel: device \
     veth78e9c4c left promiscuous mode"
