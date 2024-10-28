import AstalHyprland from 'gi://AstalHyprland';
import Battery from "gi://AstalBattery"

export default class Dependencies {

  private static _hyprland: AstalHyprland.Hyprland;
  private static _battery: Battery.Device;

  public static get hyprland() {
    if (!Dependencies._hyprland) {
      Dependencies._hyprland = AstalHyprland.get_default();
    }

    return Dependencies._hyprland;
  }

  public static get battery() {
    if (!Dependencies._battery) {
      Dependencies._battery = Battery.get_default();
    }

    return Dependencies._battery;
  }
}