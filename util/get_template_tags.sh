#!/bin/bash
###
###
###
###   Purpose:   Get all tags in a template
###   started:   2018-07-19 (pvr)
###
### ###################################################################### ###


# ================================ # ======================================= #
# global constants                 #                                         #
# -------------------------------- # --------------------------------------- #
# directories                      #                                         #
INSTALLDIR=/opt/bashtools          # installation dir of bashtools on host   #
# -------------------------------- # --------------------------------------- #
# prog paths                       # required for cronjob                    #
BASENAME=/usr/bin/basename         # PATH to basename function               #
GREP=/usr/bin/grep                 # PATH to grep                            #
SORT=/usr/bin/sort                 # PATH to sort                            #
# ================================ # ======================================= #


#Set Script Name variable
SCRIPT=`$BASENAME ${BASH_SOURCE[0]}`

# other constants

# Use utilities
UTIL=$INSTALLDIR/util/bash_utils.sh
source $UTIL

### # -------------------------------------- ###
### # functions


### # -------------------------------------------- ##
### # Main part of the script starts here ...
start_msg $SCRIPT


### # -------------------------------------------- ###
### # Use getopts for commandline argument parsing ###
### # If an option should be followed by an argument, it should be followed by a ":".
### # Notice there is no ":" after "h". The leading ":" suppresses error messages from
### # getopts. This is required to get my unrecognized option code to work.
while getopts :ut:h FLAG; do
  case $FLAG in
    u) # set option "-u" when only unique tags are wanted
      ONLYUNITAG=TRUE
      ;;
    t) # set option "t" to get template file  
      TEMPLATE=$OPTARG
	    ;;
	  h) # option -h shows usage
  	  usage $SCRIPT "Help message" "$SCRIPT -t <template_file>"
	    ;;
	  *) # invalid command line arguments
	    usage $SCRIPT "Invalid command line argument $OPTARG" "$SCRIPT -t <template_file>"
	    ;;
  esac
done  

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.


### # check that template file exists
if [ ! -f "$TEMPLATE" ]
then
  usage $SCRIPT "ERROR: Cannot find template_file: $TEMPLATE" "$SCRIPT -t <template_file>"
fi
 
### # search for template tags using grep
if [ "$ONLYUNITAG" == "TRUE" ]
then
  $GREP -o '\[[A-Z_]*\]' $TEMPLATE | $SORT -u
else
  $GREP -o '\[[A-Z_]*\]' $TEMPLATE
fi

### # -------------------------------------------- ##
### # Script ends here
end_msg $SCRIPT

### # -------------------------------------------- ##
### # What comes below is documentation that can be used with perldoc

: <<=cut
=pod

=head1 NAME

   [SCRIPT_NAME] - [SCRIPT_SHORT_TITLE]

=head1 SYNOPSIS


=head1 DESCRIPTION


=head2 Requirements



=head1 LICENSE

Artistic License 2.0 http://opensource.org/licenses/artistic-license-2.0


=head1 AUTHOR


=cut