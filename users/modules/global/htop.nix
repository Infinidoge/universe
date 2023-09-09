{ config, ... }: {
  programs.htop = {
    enable = true;
    settings = {
      fields = with config.lib.htop.fields; [
        PID
        USER
        PRIORITY
        NICE
        M_SIZE
        M_RESIDENT
        M_SHARE
        STATE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        COMM
      ];
      color_scheme = 0;
      cpu_count_from_one = 0;
      delay = 15;
      highlight_base_name = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;
      find_comm_in_cmdline = 1;
      tree_view = 1;
      header_margin = 1;
      show_cpu_usage = 1;
      show_cpu_frequency = 1;
      show_cpu_temperature = 1;
      update_process_names = 1;
    } // (with config.lib.htop; leftMeters [
      (bar "AllCPUs")
      (bar "CPU")
    ]) // (with config.lib.htop; rightMeters [
      (bar "Memory")
      (bar "Swap")
      (text "Blank")
      (text "Tasks")
      (text "LoadAverage")
      (text "Uptime")
      (text "Systemd")
      (text "DiskIO")
      (text "NetworkIO")
    ]);

  };
}
