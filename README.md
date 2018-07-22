# bashtools
Collection of useful tools for bash

## Disclaimer
The usefulnes of the tools included in this repository is completely subjective. No warranties are provided for whatsoever.

## Introduction
When working on the commandline a lot, some tasks are returning all the time. Hence it saves a lot of time to have a number 
tools available. 

## Structure
The repository is structured into subdirectories according to the different contexts in which the tools might be useful. All tools make use of some of the scripts in subdirectory `util`. Hence the presence of the content of the `util` subdirectory is required.

The following list gives an overview of the content of the different subdirectories.

* __backup__: different backup tools from generic data backup to backing up a gogs instance in a docker container.
* __sysadmin__: tools useful for sysadmin tasks such as creating users
* __template__: commonly used template files for creating new tools
* __util__:     subdirectory with utility scripts and functions


## Installation
The script `install_bashtools.sh` can be used to install either single tools or all tools within a given directory. 
