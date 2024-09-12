{
  services = {
    logind = {
      powerKey = "poweroff";
      lidSwitch = "suspend-then-hibernate";
    };

    power-profiles-daemon.enable = true;

    # battery info
    upower.enable = true;
  };
}