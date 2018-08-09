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
UT_MKDIR=/bin/mkdir                # PATH to mkdir                           #
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

### # check whether file exists, if not fail
check_exist_file_fail () {
  local l_check_file=$1
  if [ ! -f $l_check_file ]
  then
    log_msg check_exist_file_fail "FAIL because CANNOT find file: $l_check_file"
    exit 1
  fi
  # found checked file
  log_msg check_exist_file_fail "Found file: $l_check_file"
}

### # check whether a directory exits, if not fail
check_exist_dir_fail () {
  local l_check_dir=$1
  if [ ! -d "$l_check_dir" ]
  then
    log_msg check_exist_dir_fail "FAIL because CANNOT find directory: $l_check_dir"
    exit 1
  fi
  # found checked directory
  log_msg check_exist_dir_fail "Found directory: $l_check_dir"
}

### # check whether directory exists, if not create it
check_exist_dir_create () {
  local l_check_dir=$1
  if [ ! -d "$l_check_dir" ]
  then
    log_msg check_exist_dir_create "CANNOT find directory: $l_check_dir ==> create it"
    $UT_MKDIR -p $l_check_dir    
  else
    # found checked directory
    log_msg check_exist_dir_fail "Found directory: $l_check_dir"
  fi  

}
