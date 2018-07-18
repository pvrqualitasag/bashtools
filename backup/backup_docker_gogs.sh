#!/bin/bash
###
###
###
###   Purpose:   Backup Gogs Inside of docker
###   started:   2018-07-17 (pvr)
###
### ######################################### ###


#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`
TDATE=`date +"%Y%m%d"`

# other constants
GOGSCONTAINERNAME=gogs
BACKUPTARGET=/backup/docker/data

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
while getopts :h FLAG; do
  case $FLAG in
	  h) # option -h shows usage
  	  usage $SCRIPT "Help message" "$SCRIPT"
	    ;;
	  *) # invalid command line arguments
	    usage $SCRIPT "Invalid command line argument $OPTARG" "$SCRIPT"
	    ;;
  esac
done  

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.


### # determine ID of docker container
GOGSCONTAINERID=`docker ps -aqf "name=$GOGSCONTAINERNAME"`
log_msg $SCRIPT "Docker gogs container ID: $GOGSCONTAINERID"

### # start by removing old backups
docker exec $GOGSCONTAINERID /bin/bash -c "ls -1 /app/gogs/gogs-backup-*.zip" | \
while read e
do
  log_msg $SCRIPT "Removing old backup: $e"
  docker exec $GOGSCONTAINERID /bin/bash -c "rm $e"
  sleep 2
done

### # run the backupa
log_msg $SCRIPT "Running the backup ..."
docker exec -it $GOGSCONTAINERID /bin/bash -c"export USER=git && cd /app/gogs && ./gogs backup"

### # copy the backup files created today
docker exec $GOGSCONTAINERID /bin/bash -c "ls -1 /app/gogs/gogs-backup-${TDATE}*.zip" | \
while read e
do 
  log_msg $SCRIPT "Copying backupfile $e to $BACKUPTARGET"
  docker cp $GOGSCONTAINERID:$e $BACKUPTARGET
  sleep 2
done

### # -------------------------------------------- ##
### # Script ends here
end_msg $SCRIPT

### # -------------------------------------------- ##
### # What comes below is documentation that can be used with perldoc

: <<=cut
=pod

=head1 NAME

   backup_docker_gogs - Backup Gogs Inside Docker

=head1 SYNOPSIS

  backup_docker_gogs.sh


=head1 DESCRIPTION

The backup functionality of gogs is used to create a backup.zip-file. After 
running the backup, the created backup.zip-file is copied from inside the 
container to a backup-target directory on the host machine. Old backup.zip 
files are deleted before starting the backup-job. 


=head2 Requirements

The docker container running gogs must be named gogs in order to be able to 
find the correct container where the backup can be run.


=head1 LICENSE

Artistic License 2.0 http://opensource.org/licenses/artistic-license-2.0


=head1 AUTHOR

Peter von Rohr <peter.vonrohr@qualitasag.ch>

=cut