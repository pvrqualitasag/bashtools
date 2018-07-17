#!/bin/bash
###
###
###
###   Purpose:   Utility Bash Functions
###   started:   2018-07-11 (pvr)
###
### ######################################### ###

### # usage message exit with status 1
usage () {
  local l_CALLER=$1
  local l_MSG=$2
  local l_USAGE=$3
  echo " *** CALLER:  $l_CALLER"
  echo " *** MESSAGE: $l_MSG"
  echo " *** USAGE:   $l_USAGE"
  exit 1
}

### # produce a start message
start_msg () {
  local l_SCRIPT=$1
  echo "Starting $l_SCRIPT at: "`date +"%Y-%m-%d %H:%M:%S"`
}

### # produce an end message
end_msg () {
  local l_SCRIPT=$1
  echo "End of $l_SCRIPT at: "`date +"%Y-%m-%d %H:%M:%S"`
}
