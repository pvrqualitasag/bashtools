# bashtools
Collection of useful tools for bash

## Disclaimer
The usefulnes of the tools included in this repository is completely subjective. No warranties are provided for whatsoever.

## Introduction
When working on the commandline a lot, some tasks are returning all the time. Hence it saves a lot of time to have a number 
tools available. 

## Structure
The repository is structured into subdirectories according to the different contexts in which the tools might be useful. All tools make use of some of the scripts in subdirectory `util`. Hence the presence of the content of the `util` subdirectory is required.


## Revision
In the first version of project, all useful scripts were included resulting in a wide variety of scripts. Most of the included scripts could only be used in a certain environment. In this revision all scripts except those that are useful for the tasks done on the quagzws servers were moved into a different project which is called `misctools` for the moment. 


The following list gives an overview of the content of the different subdirectories.

* __create__: script to create new bash scripts or new configuration files. These scripts work all the same way. They import a given template file and replace placeholders with the specific values taken from reasonable defaults or from user input.
* __doc__: everything related to documentation
* __template__: commonly used template files for creating new tools
* __util__:     subdirectory with utility scripts and functions


## Installation
The script `install_bashtools.sh` can be used to install either single tools or all tools within a given directory. 
