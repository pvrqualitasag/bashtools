#!/bin/bash
###
###
###
###   Purpose:   Clone a git repo
###   started:   2018-09-21 (pvr)
###
### ###################################################################### ###

# ================================ # ======================================= #
# global constants                 #                                         #
# -------------------------------- # --------------------------------------- #
# directories                      #                                         #
INSTALLDIR=/opt/bashtools          # installation dir of bashtools on host   #
HOMEROOT=/home                     # root of all home directories            #
GITBRANCH=master
# -------------------------------- # --------------------------------------- #
# prog paths                       # required for cronjob                    #  
ECHO=/bin/echo                     # PATH to echo                            #
DATE=/bin/date                     # PATH to date                            #
BASENAME=/usr/bin/basename         # PATH to basename function               #
# ================================ # ======================================= #

#Set Script Name variable
SCRIPT=`$BASENAME ${BASH_SOURCE[0]}`


### # ====================================================================== #
### # functions
usage () {
  local l_MSG=$1
  $ECHO "Usage Error: $l_MSG"
  $ECHO "Usage: $SCRIPT -s <student_login> -u <github_url>"
  $ECHO "  where <student_login> login name of student"
  $ECHO "        <github_url> URL of the github repository"
  $ECHO "Recognized optional command line arguments"
  $ECHO "-b <branch>  -- specific branch name"
  exit 1
}

### # produce a start message
start_msg () {
  $ECHO "Starting $SCRIPT at: "`$DATE +"%Y-%m-%d %H:%M:%S"`
}

### # produce an end message
end_msg () {
  $ECHO "End of $SCRIPT at: "`$DATE +"%Y-%m-%d %H:%M:%S"`
}



### # ====================================================================== #
### # Use getopts for commandline argument parsing ###
### # If an option should be followed by an argument, it should be followed by a ":".
### # Notice there is no ":" after "h". The leading ":" suppresses error messages from
### # getopts. This is required to get my unrecognized option code to work.
while getopts :b:s:u:h: FLAG; do
  case $FLAG in
    b) # specify branch name
      GITBRANCH=$OPTARG
      ;;
    s) # set option "[COMMANDLINE_FLAG]"  
      STUDENTLOGIN=$OPTARG
	    ;;
	  u) # specify github url
	    GITURL=$OPTARG
	    ;;
	  h) # option -h shows usage
	    usage "Help message for $SCRIPT"
	    ;;
	  *) # invalid command line arguments
	    usage "Invalid command line argument $OPTARG"
	    ;;
  esac
done  

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.



### # ====================================================================== #
### # Main part of the script starts here ...
start_msg

### # check student login cannot be empty
if [ -z "$STUDENTLOGIN" ]
then
  usage "Login name for student cannot be empty"
fi

if [ -z "$GITURL" ]
then
  usage "Github URL cannot be empty"
fi

# save current working directory
CWD=`pwd`

# switch to student home directory
cd $HOMEROOT/$STUDENTLOGIN
git clone $GITURL -b $GITBRANCH

# change owner ship
chown -R $STUDENTLOGIN:$STUDENTLOGIN *

cd $CWD
### # ====================================================================== #
### # Script ends here
end_msg



### # ====================================================================== #
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