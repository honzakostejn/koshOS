import { bind } from 'astal';
import { Icon, Label } from 'astal/gtk3/widget';
import { IBatteryProps } from "./IBatteryProps";
import Dependencies from "../../../Dependencies";
import { fetchBatteryStatus, LOW_BATTERY } from './battery';

export default function Battery(props: IBatteryProps) {
  const updateBatteryIcon = (icon: Icon, currentBatteryStatus?: IBatteryProps) => {
    if (!currentBatteryStatus) {
      currentBatteryStatus = fetchBatteryStatus();
    }

    icon.set_icon(currentBatteryStatus.iconName);
    icon.toggleClassName('charging', currentBatteryStatus.isCharging);
    icon.toggleClassName('high', currentBatteryStatus.percentage >= 2 * LOW_BATTERY);
    icon.toggleClassName('medium', currentBatteryStatus.percentage < 2 * LOW_BATTERY);
    icon.toggleClassName('low', currentBatteryStatus.percentage < LOW_BATTERY);
  };

  return (
    <box
      className={"battery"}
    >
      {props.isPresent &&
        <button
          onClick={() => print(`Battery is present: ${Dependencies.battery.get_is_present()}, is charging: ${Dependencies.battery.get_charging()}, and the icon name is: ${Dependencies.battery.get_battery_icon_name()}`)}
        >
          <box
            // the children of the box must be defined in the children prop,
            // because nesting elements directly inside the box didn't work
            children={[
              new Icon({
                className:
                  props.isCharging ?
                    'charging' :
                    props.percentage < LOW_BATTERY ?
                      'low' :
                      props.percentage < 2 * LOW_BATTERY ?
                        'medium' :
                        'high',
                setup: (self) => {
                  updateBatteryIcon(self, props);

                  Dependencies.battery.connect('notify::percentage', () => updateBatteryIcon(self));
                  Dependencies.battery.connect('notify::icon-name', () => updateBatteryIcon(self));
                  Dependencies.battery.connect('notify::battery-icon-name', () => updateBatteryIcon(self));
                }
              }),
              new Label({
                className: "percentage",
                label: bind(Dependencies.battery, 'percentage').as((percentage) => `${Math.round(percentage * 100)}%`)
              })
            ]}
          />
        </button>
      }
    </box>
  );
}