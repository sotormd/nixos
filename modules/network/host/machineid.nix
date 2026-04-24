{ config, ... }:

{
  boot.kernelParams = [
    # systemd machine id
    "systemd.machine_id=${config.vars.device.machineId}"
  ];
}
