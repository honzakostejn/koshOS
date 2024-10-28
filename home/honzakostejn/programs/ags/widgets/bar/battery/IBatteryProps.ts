export interface IBatteryProps {
  isPresent: boolean;
  percentage: number;
  level: number;
  isCharging: boolean;
  isFullyCharged: boolean;
  iconName: string;
}