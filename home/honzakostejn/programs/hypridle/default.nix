{ pkgs
, lib
, config
, inputs
, ...
}:
let
  minuteInSeconds = 60;
  
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    # check if any player has status "Playing"
    ${lib.getExe pkgs.playerctl} -a status | ${lib.getExe pkgs.ripgrep} Playing -q
    # only suspend if nothing is playing
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  brillo = lib.getExe pkgs.brillo;

  # timeout after which DPMS kicks in
  timeout = 3 * minuteInSeconds;

  custom-hyprlock-script = import ../hyprlock/custom-hyprlock-script.nix { inherit pkgs lib; };

in
{
  # screen idle
  services.hypridle = {
    enable = true;

    package = inputs.hypridle.packages.${pkgs.system}.hypridle;

    settings = {
      general = {
        lock_cmd = "${custom-hyprlock-script}/bin/custom-hyprlock-script";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      };

      listener = [
        {
          timeout = timeout - 10;
          # save the current brightness and dim the screen over a period of
          # 1 second
          on-timeout = "${brillo} -O; ${brillo} -u 1000000 -S 10";
          # brighten the screen over a period of 500ms to the saved value
          on-resume = "${brillo} -I -u 500000";
        }
        {
          inherit timeout;
          on-timeout = ''
            #!/bin/sh
            isCharging=$(cat /sys/class/power_supply/ACAD/online)
            if [ $isCharging == 0 ]; then
              hyprctl dispatch dpms off
            fi
          '';
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = timeout + 10;
          on-timeout = suspendScript.outPath;
        }
      ];
    };
  };
}
