# System Monitoring and Process Management Script

## Overview

This Bash script is designed to monitor system resources, manage processes interactively, and provide real-time monitoring capabilities. It includes functions for logging activities, managing processes, displaying system statistics, and performing operations such as process termination and searching/filtering processes. The script utilizes configurations specified in `Task_B_Options.conf` for thresholds and intervals.

## Scripts

### Main Script (`Task_B.sh`)

- Monitors system resources (CPU and memory usage).
- Loads configurations from `Task_B_Options.conf` for thresholds and intervals.
- Includes functions from `Functions_Task_B.sh` for logging activities, managing processes, and interacting with the user.
- Provides an interactive menu for operations including listing processes, displaying process information, terminating processes, viewing system statistics, real-time monitoring, and searching/filtering processes.

## Functions

### Functions

- **log_activity**: Logs activities with timestamps to `Task_B.log`.
- **list_processes**: Lists running processes sorted by CPU and memory usage.
- **process_info**: Provides detailed information about a specified process.
- **kill_process**: Terminates a specified process by its PID.
- **process_statistics**: Displays overall system process statistics including total processes, CPU load, and memory usage.
- **real_time_monitoring**: Provides real-time monitoring of running processes.
- **search_processes**: Allows searching and filtering of processes based on user-defined criteria.
- **check_alerts**: Monitors processes for high CPU and memory usage alerts, printing and logging detected alerts.
- **cleanup**: Terminates background processes and exits the script cleanly.
- **interactive_mode**: Provides an interactive menu for the user to select and execute various operations related to process management and system monitoring.

## Prerequisites

- Ensure Bash is installed on your system.
- Create and configure `Task_B_Options.conf` for custom settings such as thresholds and intervals.
- Place `Functions_Task_B.sh` in the same directory as `Task_B.sh` to ensure all functions are accessible.

## Usage

1. **Clone the repository** to your local machine:
   ```bash
   git clone <https://github.com/OmarElmelegy/Process_Monitor.git>
   cd <repository-directory>
   ```

2. **Make the script executable**:
   ```bash
   chmod +x Task_B.sh
   ```

3. **Run the script**:
   ```bash
   ./Task_B.sh
   ```

4. **Follow the interactive menu** to perform operations related to process management and system monitoring.

## Examples

### Example 1: Starting the Script

```bash
./Task_B.sh
```

This command starts the interactive menu for the System Monitoring and Process Management script, allowing you to monitor and manage system processes interactively.

### Example 2: Custom Configuration

Edit `Task_B_Options.conf` to customize thresholds and intervals:

```bash
# Example Task_B_Options.conf
UPDATE_INTERVAL=15
CPU_THRESHOLD=85
MEMORY_THRESHOLD=90
ALERTS_INTERVAL=2
```

## Trapping Exit Signals and Cleaning Up

The script traps exit signals (`SIGINT` and `SIGTERM`) to ensure proper cleanup of background processes:

```bash
# Trap [ctrl+c] or general termination of the script to trigger cleanup
trap cleanup SIGINT SIGTERM

# Cleanup function to terminate background processes
cleanup() {
  if [[ $ALERTS_PID -ne 0 ]]; then
    kill $ALERTS_PID
  fi
  exit 0
}
```

## Error Handling

- If `Task_B_Options.conf` is missing or incorrectly configured, default settings will be used.
- Ensure `Functions_Task_B.sh` is present in the same directory as `Task_B.sh` to avoid errors related to missing functions.

## Notes

- The script provides comprehensive functionalities for managing processes and monitoring system resources interactively.
- Properly terminate the script using the interactive menu option to ensure cleanup of background processes (`cleanup` function).
---