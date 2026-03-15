{ pkgs
, lib
, ...
}:

pkgs.writeShellScriptBin "custom-hyprlock-script" ''
  hyprctl switchxkblayout all 0 # switch to the first layout - us

  hyprctl monitors -j | jq -r '.[] | .name' | while read name; do
    mkdir -p /tmp/screenshots/$name
    ${lib.getExe pkgs.grim} -o $name -l 0 /tmp/screenshots/$name/hyprlock.png
  done
  
  pidof hyprlock || hyprlock
''
