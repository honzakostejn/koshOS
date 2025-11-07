# kosh_phone
This host is a QWERTY phone running Android. Although it's not currently a fully rooted NixOS or even other Linux distribution, it can be used for development.

For that purpose, [nix-on-droid](https://github.com/nix-community/nix-on-droid) is installed on the device, which allows you to run Nix packages and manage them using the Nix package manager.

## Getting Started
1. Install `F-Droid` and `nix-on-droid` from there.
2. Run `nix-on-droid switch --flake github:honzakostejn/koshOS#kosh_phone` to set up the environment.
3. Party.

## Configuration
There are some additional steps that can improve the experience on this device.

### Sign In to Applications
TBD.
- Bitwarden
- Banking applications

### Niagara Launcher
Niagara Launcher is a minimalistic launcher that lets me access applications quickly. Configuration is exported in: TBD.

### Shortcut Keys
Since the phone has a physical keyboard, there are keys mapped to quick launch certain applications.

### Input Keyboard
FUTO - TBD.

### Disable Back Gesture
The phone has a dedicated back button, so the back gesture can be disabled to avoid accidental triggers. This tweak requires a computer.
1. Enable *Developer Options* and *USB Debugging* on the phone.
2. Connect the phone to your computer via USB.
3. Run the following on the computer (you'll probably need to approve the USB debugging prompt on the phone):
   ```bash
   nix shell nixpkgs#android-tools
   adb shell settings put secure back_gesture_inset_scale_left -1
   adb shell settings put secure back_gesture_inset_scale_right -1
   ```