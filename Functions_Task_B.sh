# Function to log activities
# Inputs: $1 - Activity message to log
# Outputs: None
# Purpose: Logs the provided activity message with a timestamp to the log file.
log_activity() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function to list running processes
# Inputs: None
# Outputs: Prints a list of running processes sorted by CPU and memory usage
# Purpose: Displays the current running processes.
list_processes() {
  echo
  ps aux --sort=-%cpu,-%mem
}

# Function to get detailed process information
# Inputs: User input for PID
# Outputs: Prints detailed information about the specified process
# Purpose: Provides detailed information about a specific process.
process_info() {
  echo
  read -p "Enter PID: " pid
  ps -p $pid -o pid,ppid,user,%cpu,%mem,cmd
}

# Function to kill a process
# Inputs: User input for PID
# Outputs: Prints success or failure message
# Purpose: Terminates the specified process by its PID.
kill_process() {
  echo
  read -p "Enter PID to kill: " pid
  kill $pid
  if [ $? -eq 0 ]; then
    log_activity "Killed process with PID $pid"
    echo "Process $pid terminated."
  else
    echo "Failed to kill process $pid."
  fi
}

# Function to display process statistics
# Inputs: None
# Outputs: Prints total number of processes, CPU load, and memory usage
# Purpose: Displays overall system process statistics.
process_statistics() {
  echo
  echo "Total Processes: $(ps -e --no-headers | wc -l)"
  echo "CPU Load: $(uptime | awk -F'[a-z]:' '{ print $2}')"
  free -h | awk 'NR==2{printf "Memory Usage: %s/%s (%.2f%%)\n", $3,$2,$3*100/$2 }'
  echo
}

# Function for real-time monitoring
# Inputs: None
# Outputs: Continuously updates the display with running processes
# Purpose: Provides real-time monitoring of running processes.
real_time_monitoring() {
  while true; do
    echo
    clear
    list_processes | head -n 20
    echo
    sleep $UPDATE_INTERVAL
  done
}

# Function to search and filter processes
# Inputs: User input for search criteria
# Outputs: Prints processes that match the search criteria
# Purpose: Allows the user to search for processes based on criteria.
search_processes() {
  echo
  read -p "Enter search criteria: " criteria
  ps aux | grep "$criteria" | grep -v grep
}

# Function to check for resource usage alerts
# Inputs: None
# Outputs: Prints and logs high resource usage alerts
# Purpose: Monitors processes and logs alerts for high CPU or memory usage.
check_alerts() {
  while true; do
    high_cpu=$(ps aux --sort=-%cpu | awk -v threshold=$CPU_THRESHOLD 'NR>1 {if ($3 > threshold) print $0}')
    high_mem=$(ps aux --sort=-%mem | awk -v threshold=$MEMORY_THRESHOLD 'NR>1 {if ($4 > threshold) print $0}')
    
    if [ ! -z "$high_cpu" ]; then
      echo "High CPU usage detected:"
      echo "$high_cpu"
      log_activity "High CPU usage detected: $high_cpu"
    fi
    
    if [ ! -z "$high_mem" ]; then
      echo "High Memory usage detected:"
      echo "$high_mem"
      log_activity "High Memory usage detected: $high_mem"
    fi

    sleep $ALERTS_INTERVAL
  done
}

# Cleanup function to terminate background processes
# Inputs: None
# Outputs: None
# Purpose: Terminates background processes and exits the script.
cleanup() {
  if [[ $ALERTS_PID -ne 0 ]]; then
    kill $ALERTS_PID
  fi
  exit 0
}

# Interactive menu function
# Inputs: User input for menu selection
# Outputs: Executes the selected menu option
# Purpose: Provides an interactive menu for the user to select operations.
interactive_mode() {
  while true; do
    clear
    echo "Simple Process Monitor"
    echo "1. List Running Processes"
    echo "2. Process Information"
    echo "3. Kill a Process"
    echo "4. Process Statistics"
    echo "5. Real-time Monitoring"
    echo "6. Search and Filter"
    echo "q. Exit"
    read -p "Choose an option: " choice
    
    case $choice in
      1) list_processes ;;
      2) process_info ;;
      3) kill_process ;;
      4) process_statistics ;;
      5) real_time_monitoring ;;
      6) search_processes ;;
      q) cleanup ;;
      *) echo "Invalid option. Try again." ;;
    esac
    
    read -p "Press Enter to continue..."
  done
}