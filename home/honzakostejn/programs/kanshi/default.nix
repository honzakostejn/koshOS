{
  ...
}: {
  services.kanshi = {
    enable = false;
    # systemdTarget = "hyprland-session.target";
    systemdTarget = "";
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.175;
            status = "enable";
          }
        ];
      }
      {
        profile.name = "docked-hub-prague";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL U2415 7MT0167B2AEL";
            position = "-1200,0";
            # mode = "1920x1200@59.95Hz";
            mode = "--custom 1920x1200@45.00Hz";  # lower bandwith required because of thunderbolt
            transform = "90";
          }
          {
            criteria = "Hewlett Packard HP LP3065 CZ49310227";
            position = "0,0";
            mode = "2560x1600@59.86Hz";
          }
          {
            criteria = "Dell Inc. DELL U2415 7MT0162411FL";
            position = "2560,0";
            mode = "1920x1200@59.95Hz";
            transform = "270";
          }
        ];
      }
    ];
  };
}
