{ pkgs
, ...
}:
let
  hibernateEnvironment = {
    HIBERNATE_SECONDS = "180";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };

in
{
  # systemd.services."awake-after-suspend-for-a-time" = {
  #   description = "Sets up the suspend so that it'll wake for hibernation only if not on AC power";
  #   wantedBy = [ "suspend.target" ];
  #   before = [ "systemd-suspend.service" ];
  #   environment = hibernateEnvironment;
  #   script = ''
  #     if [ $(cat /sys/class/power_supply/ACAD/online) -eq 0 ]; then
  #       curtime=$(date +%s)
  #       # echo "$curtime $1" >> /tmp/autohibernate.log
  #       echo "$curtime" > $HIBERNATE_LOCK
  #       ${pkgs.util-linux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
  #     # else
  #       # echo "System is on AC power, skipping wake-up scheduling for hibernation." >> /tmp/autohibernate.log
  #     fi
  #   '';
  #   serviceConfig.Type = "simple";
  # };

  # systemd.services."hibernate-after-recovery" = {
  #   description = "Hibernates after a suspend recovery due to timeout";
  #   wantedBy = [ "suspend.target" ];
  #   after = [ "systemd-suspend.service" ];
  #   environment = hibernateEnvironment;
  #   script = ''
  #     curtime=$(date +%s)
  #     sustime=$(cat $HIBERNATE_LOCK)
  #     rm $HIBERNATE_LOCK
  #     if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
  #       systemctl hibernate
  #     else
  #       ${pkgs.util-linux}/bin/rtcwake -m no -s 1
  #     fi
  #   '';
  #   serviceConfig.Type = "simple";
  # };

  # services = {
  #   logind = {
  #     powerKey = "poweroff";
  #     lidSwitch = "suspend";
  #     # `suspend-then-hibernate` option hibernates only at 5% of remaining battery
  #     # thus hibernation is automated with `HIBERNATE_SECONDS`
  #   };

  #   power-profiles-daemon.enable = true;

  #   # battery info
  #   upower.enable = true;
  # };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.thermald.enable = true;
  services.upower.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;

      # optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0 = 85;
    };
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
