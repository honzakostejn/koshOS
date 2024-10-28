import { bind } from 'astal';
import { Gtk } from "astal/gtk3"
import { IBatteryProps } from "./IBatteryProps";
import Dependencies from "../../../Dependencies";
import { fetchBatteryStatus, LOW_BATTERY } from './battery';

export default function Battery(props: IBatteryProps) {
  return (
    <box
      className={"battery"}
    >
      {Dependencies.battery.get_is_present() &&
        <icon
          setup={(self) => {
            const update = () => {
              const currentBatteryStatus = fetchBatteryStatus();

              self.set_icon(currentBatteryStatus.iconName);
              self.toggleClassName('charging', currentBatteryStatus.isCharging);
              self.toggleClassName('fullyCharged', currentBatteryStatus.isFullyCharged);
              self.toggleClassName('low', currentBatteryStatus.percentage < LOW_BATTERY);
            };

            update();

            Dependencies.battery.connect('notify::percentage', () => update());
            Dependencies.battery.connect('notify::icon-name', () => update());
            Dependencies.battery.connect('notify::battery-icon-name', () => update());
          }}
        />
      }
      <label label={bind(Dependencies.battery, 'percentage').as((percentage) => `${Math.round(percentage * 100)}%`)} />
    </box>
  );
}