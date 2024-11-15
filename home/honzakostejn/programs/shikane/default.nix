{
  ...
}: {
  imports = [
    ./shikane.nix
  ];

  services.shikane = {
    enable = true;
    systemdTarget = [
      "graphical-session.target"
    ];
    config = ''
      [[profile]]
      name = "undocked"
      # exec = ["swww-daemon & swww img /home/honzakostejn/koshos/assets/wallpapers/forest-fire.gif --filter Nearest"]
        [[profile.output]]
        match = "eDP-1"
        enable = true
        scale = 1.175

      [[profile]]
      name = "docked-hub-prague"
      # exec = ["swww-daemon & swww img /home/honzakostejn/koshos/assets/wallpapers/forest-fire.gif --filter Nearest"]
        [[profile.output]]
        match = "eDP-1"
        enable = false

        [[profile.output]]
        search = [ "s=7MT0167B2AEL" ]
        position = "-1200,0"
        transform = "90"
        enable = true

        [[profile.output]]
        search = [ "s=CZ49310227" ]
        position = "0,0"
        enable = true
        
        [[profile.output]]
        search = [ "s=7MT0162411FL" ]
        position = "2560,0"
        transform = "270"
        enable = true
    '';
  };
}