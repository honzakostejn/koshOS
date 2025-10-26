#!/usr/bin/env bash

MODE=""
FREEZE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --freeze)
      FREEZE=true
      shift
      ;;
    region|screen|window)
      MODE="$1"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$MODE" ]]; then
  echo "Usage: $0 <region|screen|window> [--freeze]"
  exit 1
fi

if [[ "$FREEZE" == true ]]; then
  sleep 3
fi

YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
TIMESTAMP=$(date +%s)

SCREENSHOT_DIR="$HOME/screenshots/hyprshot/$YEAR/$MONTH/$DAY"
mkdir -p "$SCREENSHOT_DIR"

case "$MODE" in
  region)
    HYPRSHOT_MODE="region"
    HYPRSHOT_ARGS=""
    SUFFIX="region"
    ;;
  screen)
    HYPRSHOT_MODE="output"
    HYPRSHOT_ARGS=""
    SUFFIX=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
    ;;
  window)
    HYPRSHOT_MODE="window"
    HYPRSHOT_ARGS="-m active"
    SUFFIX=$(hyprctl activewindow -j | jq -r '.class')
    ;;
  *)
    echo "Invalid mode: $MODE"
    exit 1
    ;;
esac

FILENAME="${TIMESTAMP}_${SUFFIX}.png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

if [[ "$FREEZE" == true ]]; then
  hyprshot -m "$HYPRSHOT_MODE" "$HYPRSHOT_ARGS" --freeze --raw | satty -f - -o "$FILEPATH"
else
  hyprshot -m "$HYPRSHOT_MODE" "$HYPRSHOT_ARGS" --raw | satty -f - -o "$FILEPATH"
fi
echo "Screenshot saved to: $FILEPATH"
