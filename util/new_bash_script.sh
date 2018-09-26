#!/bin/bash
###
###
###
###   Purpose:   Create new bash script based on a template
###   started:   2018-08-09 (pvr)
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
# ================================ # ======================================= #


#Set Script Name variable
SCRIPT=`$BASENAME ${BASH_SOURCE[0]}`

# other constants
TEMPLATEPATH=$INSTALLDIR/template/bash/bash_script_ut.template
GETTAGSCRIPT=$INSTALLDIR/util/get_template_tags.sh

# Use utilities
UTIL=$INSTALLDIR/util/bash_utils.sh
source $UTIL


### # ====================================================================== #
### # functions


### # ====================================================================== #
### # Main part of the script starts here ...
start_msg $SCRIPT


### # ====================================================================== #
### # Use getopts for commandline argument parsing                         ###
### # If an option should be followed by an argument, it should be followed by a ":".
### # Notice there is no ":" after "h". The leading ":" suppresses error messages from
### # getopts. This is required to get my unrecognized option code to work.
while getopts :t:h FLAG; do
  case $FLAG in
    t) # set option "-t"  to specify the template file
      TEMPLATEPATH=$OPTARG
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

### # checking prerequisits
check_exist_file_fail $TEMPLATEPATH
check_exist_file_fail $GETTAGSCRIPT


### # in a loop over all tags in the template file, ask the user what value
### #  should be inserted into the template
# $GETTAGSCRIPT -t $TEMPLATEPATH -u | \
# while read tag
# do
#   log_msg $SCRIPT "Current tag: $tag"
#   
# done

tags=()
$GETTAGSCRIPT -t $TEMPLATEPATH -u | \
while read tag
do
  tags=(${tags[@]} ${tag})
  log_msg $SCRIPT "Current tag: $tag"
done

echo "Tags: ${tags[@]}"

# loop over tags
for i in ${!tags[@]}
do
  log_msg $SCRIPT "Tag loop $i: ${tags[i]}"
done  

Fruits=(Apple Mango Orange Banana Grapes Watermelon);

Fruits=(${Fruits[@]} Blackberry Blueberry)

echo "${Fruits[@]}"

### # ====================================================================== #
### # Script ends here
end_msg $SCRIPT

### # ====================================================================== #
### # What comes below is documentation that can be used with perldoc

: <<=cut
=pod

=head1 NAME

   new_bash_script - Create new bash script based on a template

=head1 SYNOPSIS

   new_bash_script.sh -t <template_file>

=head1 DESCRIPTION

Most bash scripts have a very similar structure. This is even more true with 
the requirements imposed by reproducible workflows. To make the creation of 
new bash scripts as seamless as possible, the common parts are collected into 
a template file. The components that vary between different bash scripts are 
denoted by so-called tags which are place-holders for certain chunks of 
information. When a new bash script is created these tags must be replaced 
by the actual values of a given script. 

This script asks the user for the actual values with which the different 
tags in a template should be replaced with.


=head2 Requirements

When specifying a template file, this file must exist.


=head1 LICENSE

Artistic License 2.0 http://opensource.org/licenses/artistic-license-2.0


=head1 AUTHOR

Peter von Rohr <peter.vonrohr@qualitasag.ch>

=cut