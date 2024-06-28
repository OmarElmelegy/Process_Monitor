#!/usr/bin/bash -i

# Load Configuration file
CONFIG_FILE="./Task_B_Options.conf"
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  # Default configurations
  UPDATE_INTERVAL=5
  CPU_THRESHOLD=80
  MEMORY_THRESHOLD=80
fi

# Load Helper functions file
HELPER_FILE="./Functions_Task_B.sh"
if [ -f "$HELPER_FILE" ]; then
  source "$HELPER_FILE"
else
  echo "Helper Functions Script file Does not exist, check it and rerun the script.."
  exit 1
fi

LOG_FILE="./Task_B.log"


# Start checking alerts in the background
check_alerts &
# Capture Alerts pid to cleanup after the program exits
ALERTS_PID=$!
# Trap [ctrl+c] or general termination of the process of the script to trigger cleanup
trap cleanup SIGINT SIGTERM

# Start interactive mode
interactive_mode