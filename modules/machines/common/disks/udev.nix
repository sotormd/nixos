{ pkgs, lib, ... }:

let
  # io scheduler rules
  # from https://wiki.archlinux.org/title/Improving_performance#Input/output_schedulers
  ioschedulerRules = [
    # nvme drives - use none scheduler for lowest latency
    # from https://wiki.archlinux.org/title/Improving_performance#Changing_I.2FO_scheduler
    # nvme drives handle >10,000 IOPS and dont benefit from queuing algorithms
    ''ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"''

    # sata ssds - use mq-deadline for better throughput
    # from https://wiki.archlinux.org/title/Improving_performance#The_scheduling_algorithms
    # mq-deadline provides good throughput with fairness guarantees
    ''ACTION=="add|change", KERNEL=="sd[a-z]", DRIVERS=="sd", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"''

    # hdds - use bfq for fair scheduling
    # from https://wiki.archlinux.org/title/Improving_performance#The_scheduling_algorithms
    # bfq focuses on low latency for interactive tasks on rotational drives
    ''ACTION=="add|change", KERNEL=="sd[a-z]", DRIVERS=="sd", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"''
  ];

  # sata active link power management
  # from https://wiki.archlinux.org/title/Improving_performance#SATA_Active_Link_Power_Management
  # sets sata link power management to max_performance to prevent latency spikes
  # this prevents sata drives from entering power-saving modes that can cause delays
  # particularly important for sata ssds and hdds used for active workloads
  sataPowerManagementRules = [
    ''ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}=="*", ATTR{link_power_management_policy}="max_performance"''
  ];

  # hdd power management with hdparm
  # from https://wiki.archlinux.org/title/Improving_performance#hdparm
  # sets advanced power management to 254 and disables standby timer
  # apm 254: allows drive to manage power efficiently without aggressive spin-down and head parking
  # standby disabled: prevents automatic spin-down, reducing latency spikes
  # only applies to rotational drives - hdds not ssds
  hdparmRules = [
    ''ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${pkgs.hdparm}/sbin/hdparm -B 254 -S 0 /dev/%k"''
  ];

  # combine all rules
  allRules = ioschedulerRules ++ sataPowerManagementRules ++ hdparmRules;
in
{
  services.udev.extraRules = lib.concatStringsSep "\n" allRules;
}
