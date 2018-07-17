#!/bin/bash
###
###
###
###   Purpose:   Create data backups
###   started:   2018-07-11 (pvr)
###
### ######################################### ###


#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`

# other constants

# Use utilities
UTIL=../util/bash_utils.sh
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
while getopts :s:t:h FLAG; do
  case $FLAG in
    s) # set option "s" for source directory  
      SOURCEDIR=$OPTARG
	    ;;
	  t) # set option "-t" for target directory
	    TARGETDIR=$OPTARG
	    ;;
	  h) # option -h shows usage
	    usage $SCRIPT "Help message" "$SCRIPT -s <source> -t <target>"
	    ;;
	  *) # invalid command line arguments
	    usage $SCRIPT "Invalid command line argument $OPTARG" "$SCRIPT -s <source> -t <target>"
	    ;;
  esac
done  

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### # checks
### # source and target directories must exist

### # -------------------------------------------- ##
### # Script ends here
end_msg $SCRIPT

### # -------------------------------------------- ##
### # What comes below is documentation that can be used with perldoc

: <<=cut
=pod

=head1 NAME

   backup_data - Create Data Backups

=head1 SYNOPSIS

   backup_data.sh -s <source_dir> -t <target_dir>
   
   where -s specifies the source directory to be backed up
         -t specifies the target directory under which the backup should be stored


=head1 DESCRIPTION

Backups of single data directories are generated using tar. The outcome of this 
simple approach may vary depending on the system on which the backup is created. 
On Linux-based systems it should be possible to create backups from all data 
to which the user who calls the script has access to. The created backups are 
stored in compressed files and are stored into the target directory that is also 
specified. The user who runs this script must have write-permission in the target 
directory and the target directory must have enough space to be able to store the 
created backup file.


=head2 Requirements

The data directory that is specified as source directory using option -s must 
exist and the user who executes this script must have sufficient permission 
to read the data from this directory. 

The target directory which is specified using option -t must exist and the user 
who runs the backup must have write-permission in that directory. Furthermore 
the amount of available space on the medium where the target directory is 
located, must be sufficient to store the created backup file. 


=head1 LICENSE

Artistic License 2.0 http://opensource.org/licenses/artistic-license-2.0


=head1 AUTHOR

Peter von Rohr (peter.vonrohr@qualitasag.ch)
=cut