#!/bin/bash
###
###
###
###   Purpose:   Create user accounts
###   started:   2018/04/11 (pvr)
###
### ######################################### ###


#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`


### # functions
usage () {
  local l_MSG=$1
  echo "Usage Error: $l_MSG"
  echo "Usage: $SCRIPT -u <username>"
  echo "  where <username> specifies the name of the new user"
  echo "Recognized optional command line arguments"
  echo "-s <shell>  -- Set the default shell"
  exit 1
}

### # produce a start message
start_msg () {
  echo "Starting $SCRIPT at: "`date +"%Y-%m-%d %H:%M:%S"`
}

### # produce an end message
end_msg () {
  echo "End of $SCRIPT at: "`date +"%Y-%m-%d %H:%M:%S"`
}

### # check whether user is sudoer which includes root
check_for_sudo () {
  l_prompt=$(sudo -nv 2<&1)
  if [ `echo $l_prompt | grep sudo | wc -l` -gt "0" ]
  then
    usage "User must have sudoer rights"
  fi
}

### # generate a random passord
generate_password () {
  # This will generate a random, 8-character password:
  PASSWORD=`tr -dc A-Za-z0-9_ < /dev/urandom | head -c8`
  echo $PASSWORD > $l_USERNAME
}

### # create the user using useradd and set the password
create_user () {
  local l_USERNAME=$1
  local l_PASS=$2
  local l_DEFAULTSHELL=$3

   
  # add user account
  useradd $l_USERNAME -s $l_DEFAULTSHELL -m

  # This will actually set the password:
  echo "$l_USERNAME:$l_PASS" | chpasswd  
}  

### Start getopts code ###
#Parse command line flags
#If an option should be followed by an argument, it should be followed by a ":".
#Notice there is no ":" after "h". The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.
while getopts :p:u:s: FLAG; do
  case $FLAG in
    p) # set option "p" to indicate password
      PASSWORD=$OPTARG
	    ;;
    u) # set option "u" for username
      USERNAME=$OPTARG
	    ;;
	  s) # set option "s" for default shell
	    DEFAULTSHELL=$OPTARG
	    [ -e "${DEFAULTSHELL}" ] || usage "Cannot find pecified shell ${DEFAULTSHELL}"
	    ;;
	  *) # invalid command line arguments
	    usage "Invalid command line argument $OPTARG"
	    ;;
  esac
done  

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### # create the user and write the password to a file
start_msg

### # checks
if [ -z "${USERNAME}" ]
then
  usage 'Username must be spedified with -u <username>'
fi

### # home directory of user should not exist
USERHOME="/home/${USERNAME}"
if [ -e "$USERHOME" ]
then
  usage "Home directory $USERHOME already exists - Stop here." 
fi

### # this script must be run as sudoer
check_for_sudo

### # generate password if it was not specified
if [ -z "$PASSWORD" ]
then
  generate_password
fi


### # call creation function
create_user $USERNAME $PASSWORD $DEFAULTSHELL

### # end of script
end_msg

: <<=cut
=pod

=head1 NAME

   create_user.sh - Shell script for creating user accounts

=head1 SYNOPSIS

   create_user.sh -u <username>
   
      where: <username> sets the name of the new user

   Recognized optional command line arguments
      -s <shell>     -- Set the default shell
      -p <password>  -- Specify a given password


=head1 DESCRIPTION

This is a wrapper for the useradd command. In addition to that a 
random password is written to a file which has the same name as 
the user.


=head2 Requirements

This script can only be run as a user with root priviledges.


=head1 LICENSE

Artistic License 2.0 http://opensource.org/licenses/artistic-license-2.0


=head1 AUTHOR

Peter von Rohr <peter.vonrohr@qualitasag.ch>

=cut