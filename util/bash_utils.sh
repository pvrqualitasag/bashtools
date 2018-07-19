#!/bin/bash
###
###
###
###   Purpose:   Utility Bash Functions
###   started:   2018-07-11 (pvr)
###
### ###################################################################### ###

# ================================ # ======================================= #
# prog paths                       # required for cronjob                    #  
UT_ECHO=/bin/echo                  # PATH to echo                            #
UT_DATE=/bin/date                  # PATH to date                            #
# ================================ # ======================================= #

### # usage message exit with status 1
usage () {
  local l_CALLER=$1
  local l_MSG=$2
  local l_USAGE=$3
  $UT_ECHO " *** CALLER:  $l_CALLER"
  $UT_ECHO " *** MESSAGE: $l_MSG"
  $UT_ECHO " *** USAGE:   $l_USAGE"
  exit 1
}

### # produce a start message
start_msg () {
  local l_SCRIPT=$1
  $UT_ECHO "Starting $l_SCRIPT at: "`$UT_DATE +"%Y-%m-%d %H:%M:%S"`
}

### # produce an end message
end_msg () {
  local l_SCRIPT=$1
  $UT_ECHO "End of $l_SCRIPT at: "`$UT_DATE +"%Y-%m-%d %H:%M:%S"`
}

### # functions related to logging
log_msg () {
  local l_CALLER=$1
  local l_MSG=$2
  local l_RIGHTNOW=`$UT_DATE +"%Y%m%d%H%M%S"`
  $UT_ECHO "[${l_RIGHTNOW} -- ${l_CALLER}] $l_MSG"
}