#!/bin/bash
###
###
###
###   Purpose:   [SCRIPT_PURPOSE]
###   started:   [START_DATE] ([SCRIPT_AUTHOR])
###
### ######################################### ###


#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`

# other constants
GOGSCONTAINERNAME=gogs

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
while getopts :[COMMANDLINE_FLAG]:h FLAG; do
  case $FLAG in
    [COMMANDLINE_FLAG]) # set option "[COMMANDLINE_FLAG]"  
      [OPTION_STATEMENT]
	    ;;
	  h) # option -h shows usage
  	  usage $SCRIPT "Help message" "$SCRIPT -[COMMANDLINE_FLAG] [COMMANDLINE_VALUE]"
	    ;;
	  *) # invalid command line arguments
	    usage $SCRIPT "Invalid command line argument $OPTARG" "$SCRIPT -[COMMANDLINE_FLAG] [COMMANDLINE_VALUE]"
	    ;;
  esac
done  

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.


### # determine ID of docker container
GOGSCONTAINERID=`docker ps -aqf "name=$GOGSCONTAINERNAME"`

### # start by removing old backups
#docker exec $(docker ps -a -q) /bin/bash -c "ls -1 /app/gogs/gogs-backup-20180717*" | while read e;do echo $e;docker cp $(docker ps -a -q):$e .;sleep 2;done

### # run the backup
docker exec -it $(docker ps -a -q) /bin/bash -c"export USER=git && cd /app/gogs && ./gogs backup"

### # copy the backup files
docker exec $(docker ps -a -q) /bin/bash -c "ls -1 /app/gogs/gogs-backup-20180717*" | while read e;do echo $e;docker cp $(docker ps -a -q):$e .;sleep 2;done

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