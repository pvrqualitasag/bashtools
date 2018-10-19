#!/bin/bash
###
###
###
###   Purpose:   Create branch specific subdirectories
###   started:   2018-10-17 08:38:10 (pvr)
###
### ###################################################################### ###

set -o errexit    # exit immediately, if single command exits with non-zero status
set -o nounset    # treat unset variables as errors
set -o pipefail   # return value of pipeline is value of last command to exit with non-zero status
                  #  hence pipe fails if one command in pipe fails

# #
# ======================================== # ============================================= #
# global constants                         #                                               #
# ---------------------------------------- # --------------------------------------------- #
# prog paths                               #                                               #
BASENAME=/usr/bin/basename                 # PATH to basename function                     #
DIRNAME=/usr/bin/dirname                   # PATH to dirname function                      #
# ---------------------------------------- # --------------------------------------------- #
# directories                              #                                               #
INSTALLDIR=`$DIRNAME ${BASH_SOURCE[0]}`    # installation dir of bashtools on host         #
UTILDIR=/opt/bashtools/util                # directory containing utilities of bashtools   #
# ---------------------------------------- # --------------------------------------------- #
# files                                    #                                               #
SCRIPT=`$BASENAME ${BASH_SOURCE[0]}`       # Set Script Name variable                      #
# ---------------------------------------- # --------------------------------------------- #
# other constants                          #                                               #
BRANCHES=(master gh-pages)
# ======================================== # ============================================= #


# Use utilities
UTIL=$UTILDIR/bash_utils.sh
source $UTIL


### # ====================================================================== #
### # functions


### # ====================================================================== #
### # Use getopts for commandline argument parsing                         ###
### # If an option should be followed by an argument, it should be followed by a ":".
### # Notice there is no ":" after "h". The leading ":" suppresses error messages from
### # getopts. This is required to get my unrecognized option code to work.
proj_dir=""
while getopts ":p:h" FLAG; do
  case $FLAG in
    h) # option -h shows usage
      usage $SCRIPT "Help message" "$SCRIPT -p <project_dir>"
      ;;
    p)
      proj_dir=$OPTARG
      ;;
    :)
      usage "-$OPTARG requires an argument"
      ;;
    ?)
      usage "Invalid command line argument (-$OPTARG) found"
      ;;
  esac
done  

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.


### # ====================================================================== #
### # Main part of the script starts here ...
start_msg $SCRIPT

# Check whether required arguments have been defined
if test "$proj_dir" == ""; then
  usage $SCRIPT "value of project_directory not defined" "$SCRIPT -p <project_dir>"
fi

# check whether project_directory exists
check_exist_dir_fail $proj_dir

### # Create root directory and branch specific subdirectories
proj_root="${proj_dir}_gh-root"
for b in "${BRANCHES[@]}"
do
  log_msg $SCRIPT "Create directory $proj_root/$b"
  mkdir -p $proj_root/$b
done  

### # move proj_dir to proj_root/master/
mv $proj_dir $proj_root/master

### # ====================================================================== #
### # Script ends here
end_msg $SCRIPT 


### # ====================================================================== #
### # What comes below is documentation that can be used with perldoc

: <<=cut
=pod

=head1 NAME

   creat_branch_root - Github branch subdirectories

=head1 SYNOPSIS


=head1 DESCRIPTION

Create from a given github working directory subdirectories for different branches. Currently, we use only two branches master and gh-pages


=head2 Requirements



=head1 LICENSE

Artistic License 2.0 http://opensource.org/licenses/artistic-license-2.0


=head1 AUTHOR

Peter von Rohr <peter.vonrohr@qualitasag.ch>


=head1 DATE

2018-10-17 08:38:10


=cut
