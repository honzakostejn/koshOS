import Dependencies from "../../../Dependencies";
import { IBatteryProps } from "./IBatteryProps";

export const LOW_BATTERY = 25;

export const fetchBatteryStatus = (): IBatteryProps => {
  const isPresent = Dependencies.battery.get_is_present();
  const percentage = Math.round(Dependencies.battery.get_percentage() * 100);
  const level = Math.floor(percentage / 10) * 10;
  const isCharging = Dependencies.battery.get_charging();
  const isFullyCharged = percentage === 100 && isCharging;
  const iconName = Dependencies.battery.get_battery_icon_name();

  return {
    isPresent,
    percentage,
    level,
    isCharging,
    isFullyCharged,
    iconName
  }
};