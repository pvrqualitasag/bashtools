#!/bin/bash
###
###
###
###   Purpose:   Installation script for required libraries for R and R itself
###   started:   2018-04-18 (pvr)
###
### ############################################################################ ###

set -o errexit
set -o pipefail
set -o nounset

### # Global constants
DRYRUN="FALSE"

### # directories
SRCHOME=/qualstorzws01/data_tmp
DOWNLOADSRC=$SRCHOME/source
INHOME=/qualstorzws01/data_projekte
LOCALLIB=$INHOME/linuxLib_5.5.0

### # defaults for options
ZLIBINSTALL="FALSE"
BZLIBINSTALL="FALSE"
LIBZMAINSTALL="FALSE"
PCREINSTALL="FALSE"
OPENSSLINSTALL="FALSE"
CURLINSTALL="FALSE"
READLINEINSTALL="FALSE"
NCURSESINSTALL="FALSE"
BINUTILSINSTALL="FALSE"
GCCINSTALL="FALSE"
RSRCINSTALL="FALSE"


### # functions
usage () {
  local l_MSG=$1
  echo "Usage Error: $l_MSG"
  echo "Usage $SCRIPT -s <download_src_dir> -u <local_lib_path>"
  echo "  where <download_src_dir> is the directory where source files are downloaded to"
  echo "        <local_lib_path> is the library to where libraries get installed"
}

### # download and extract a given source tar.gz
download_extract () {
  local l_lib_name=$1
  local l_dl_url=$2
  # check whether old lib dir is available, if yes delete it
  if [ -d "$l_lib_name" ];then rm -rf $l_lib_name;fi
  # check whether tar.gz exists, if not download it from l_dl_url
  if [ ! -f "${l_lib_name}.tar.gz" ];then wget $l_dl_url;fi;
  # extract the tar.gz
  tar xvzf ${l_lib_name}.tar.gz
  
}

### # confiugre and compile the downloaded sources
default_compile () {
  local l_loc_lib=$1
  if [ "$DRYRUN" = "TRUE" ]
  then
    echo " *** DRYRUN ./configure --prefix=$l_loc_lib"
    echo " *** DRYRUN make;make install"
  else
    # run configure
    ./configure --prefix=$l_loc_lib
    # compile and install
    make
    make install
  fi  
}



### # Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`

### # start
echo "*** Starting $SCRIPT at: "`date`

### # Parsing command line arguments
while getopts :s:u:zbmpoclntgrda FLAG; do
  case $FLAG in
    s) # take value after argument "s" as directory for download source
    DOWNLOADSRC=$OPTARG
	  ;;
	  u) # take value after argument "u" as directory for locallib
	  LOCALLIB=$OPTARG
	  ;;
	  z) # set option "z" for installing zlib
	  ZLIBINSTALL="TRUE"
	  ;;
	  b) # set option "b" for installing BZLIB
	  BZLIBINSTALL="TRUE"
	  ;;
	  m) # set option "m" for installing LIBZMA
	  LIBZMAINSTALL="TRUE"
	  ;;
	  p) # set option "p" for installing PCRE
	  PCREINSTALL="TRUE"
	  ;;
	  o) # set option "o" for installing OPENSSL
	  OPENSSLINSTALL="TRUE"
	  ;;
	  c) # set option "c" for installing CURL
	  CURLINSTALL="TRUE"
	  ;;
	  l) # set option "l" for installing READLINE
	  READLINEINSTALL="TRUE"
	  ;;
	  n) # set option "n" for installing NCURSES
	  NCURSESINSTALL="TRUE"
	  ;;
	  t) # set option "t" for installing gnu binutils
	  BINUTILSINSTALL="TRUE"
	  ;;
	  g) # set option "g" for installing GCC
	  GCCINSTALL="TRUE"
	  ;;
	  r) # set option "r" for installing R
	  RSRCINSTALL="TRUE"
	  ;;
	  d) # set option d for dryrun
	  DRYRUN="TRUE"
	  ;;
	  a) # set option "a" for installing all of them
	  ZLIBINSTALL="TRUE"
    BZLIBINSTALL="TRUE"
    LIBZMAINSTALL="TRUE"
    PCREINSTALL="TRUE"
    OPENSSLINSTALL="TRUE"
    CURLINSTALL="TRUE"
    READLINEINSTALL="TRUE"
    NCURSESINSTALL="TRUE"
    BINUTILSINSTALL="TRUE"
    GCCINSTALL="TRUE"
    # RSRCINSTALL="TRUE"
    ;;
  	*) # invalid command line arguments
	  usage "Invalid command line argument $OPTARG"
	  ;;
  esac
done  

shift $((OPTIND-1)) 

### # at this point, the variables DOWNLOADSRC and LOCALLIB must be set


### # if local library path does not exist, create it
if [ ! -d "$LOCALLIB" ]
then
  echo "*** * Creating local library: $LOCALLIB"
  mkdir $LOCALLIB
fi
### # if downloadsource does not exist, create it
if [ ! -d "$DOWNLOADSRC" ]
then
  echo "*** * Creating local library: $DOWNLOADSRC"
  mkdir $DOWNLOADSRC
fi

### # installation of libraries
### #  zlib
if [ "$ZLIBINSTALL" = "TRUE" ]
then
  ZLIB=zlib-1.2.11
  DLURLZLIB=http://zlib.net/${ZLIB}.tar.gz
  # switch to download src dir
  cd $DOWNLOADSRC
  download_extract $ZLIB $DLURLZLIB
  cd ${ZLIB}
  default_compile $LOCALLIB
fi

### # adjust paths
if [ "$DRYRUN" != "TRUE" ]
then
  export PATH=$LOCALLIB/bin:$PATH
  export LD_LIBRARY_PATH=$LOCALLIB/lib:$LD_LIBRARY_PATH 
  export CFLAGS="-I$LOCALLIB/include" 
  export LDFLAGS="-L$LOCALLIB/lib" 
fi

### bzlib
if [ "$BZLIBINSTALL" = "TRUE" ]
then
  BZLIB=bzip2-1.0.6
  DLURLBZLIB=http://www.bzip.org/1.0.6/${BZLIB}.tar.gz
  echo " *** Installation of $BZLIB from $DLURLBZLIB ..."
  # switch to download src dir
  cd $DOWNLOADSRC
  # check whether sources were already downloaded
  if [ !  -d "${BZLIB}" ]
  then
    git clone https://github.com/enthought/bzip2-1.0.6.git
  fi  
  cd $BZLIB
  if [ "$DRYRUN" = "TRUE" ]
  then
    echo " *** DRYRUN compile and install of $BZLIB"
  else
    make -f Makefile-libbz2_so
    make clean
    make -n install PREFIX=$LOCALLIB
    make install PREFIX=$LOCALLIB
  fi
fi

### liblzma
if [ "$LIBZMAINSTALL" = "TRUE" ]
then
  LIBZMA=xz-5.2.3
  DLURLLIBZMA="https://tukaani.org/xz/${LIBZMA}.tar.gz"
  echo " *** Installation of $LIBZMA from $DLURLLIBZMA ..."
  cd $DOWNLOADSRC
  download_extract $LIBZMA $DLURLLIBZMA
  cd $LIBZMA
  default_compile $LOCALLIB
fi

### pcre
if [ "$PCREINSTALL" = "TRUE" ]
then
  PCRE=pcre-8.38
  DLURLPCRE=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${PCRE}.tar.gz
  echo " *** Installation of $PCRE from $DLURLPCRE ..."
  cd $DOWNLOADSRC
  download_extract $PCRE $DLURLPCRE
  cd $PCRE
  if [ "$DRYRUN" = "TRUE" ]
  then
    echo " *** DRYRUN configure;compile and install of $PCRE"
  else
    ./configure --enable-utf8 --prefix=$LOCALLIB
    make -j3
    make install
  fi
fi

### openssl
if [ "$OPENSSLINSTALL" = "TRUE" ]
then
  OPENSSL=openssl-1.0.2o
  DLURLOPENSSL=https://www.openssl.org/source/${OPENSSL}.tar.gz
  echo " *** Installation of $OPENSSL from $DLURLOPENSSL ..."
  cd $DOWNLOADSRC
  download_extract $OPENSSL $DLURLOPENSSL
  cd ${OPENSSL}
  if [ "$DRYRUN" = "TRUE" ]
  then
    echo " *** DRYRUN configure;compile and install of $OPENSSL"
  else
    make clean
    ./config --prefix=$LOCALLIB/openssl --openssldir=$LOCALLIB/openssl shared -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'
    make
    make install
    ### # add openssl/bin to path
    export PATH=$LOCALLIB/openssl/bin:$PATH
  fi  
fi


### curl
if [ "$CURLINSTALL" = "TRUE" ]
then
  CURL=curl-7.56.1
  DLURLCURL="https://curl.haxx.se/download/${CURL}.tar.gz"
  echo " *** Installation of $CURL from $DLURLCURL ..."
  cd $DOWNLOADSRC
  download_extract $CURL $DLURLCURL
  cd ${CURL}
  if [ "$DRYRUN" = "TRUE" ]
  then
    echo " *** DRYRUN configure;compile and install of $CURL"
  else
    ./configure --prefix=$LOCALLIB --with-ssl=$LOCALLIB/openssl
    make -j3
    make install
  fi
fi

### readline
if [ "$READLINEINSTALL" = "TRUE" ]
then
  READLINE=readline-7.0
  DLURLREADLINE=http://ftp.gnu.org/gnu/readline/${READLINE}.tar.gz
  echo " *** Installation of $READLINE from $DLURLREADLINE ..."
  cd $DOWNLOADSRC
  download_extract $READLINE $DLURLREADLINE
  cd ${READLINE}
  default_compile $LOCALLIB
fi

### ncurses
if [ "$NCURSESINSTALL" = "TRUE" ]
then
  NCURSES=ncurses-6.1
  DLURLNCURSES=http://ftp.gnu.org/pub/gnu/ncurses/${NCURSES}.tar.gz
  echo " *** Installation of $NCURSES from $DLURLNCURSES ..."
  cd $DOWNLOADSRC
  download_extract $NCURSES $DLURLNCURSES
  cd ${NCURSES}
  default_compile $LOCALLIB
fi


### binutils
if [ "$BINUTILSINSTALL" = "TRUE" ]
then
  BINUTIL=binutils-2.31.1
  DLURLBU=https://mirror.init7.net/gnu/binutils/${BINUTIL}.tar.gz
  echo " *** Installation of $BINUTIL from $DLURLBU ..."
  cd $DOWNLOADSRC
  download_extract $BINUTIL $DLURLBU
  cd ${BINUTIL}
  default_compile $LOCALLIB
fi

### gcc
if [ "$GCCINSTALL" = "TRUE" ]
then
  GCC=gcc-5.5.0
  DLURLGCC=https://mirror.init7.net/gnu/gcc/${GCC}/${GCC}.tar.gz
  echo " *** Installation of $GCC from $DLURLGCC ..."
  cd $DOWNLOADSRC
  download_extract $GCC $DLURLGCC
  cd ${GCC}
  if [ "$DRYRUN" = "TRUE" ]
  then
    echo " *** DRYRUN configure;compile and install of $GCC"
  else
    ./contrib/download_prerequisites
    cd ..
    mkdir objdir
    cd objdir
    ### # --disable-multilib says that gcc will only build 64-bit 
    ../${GCC}/configure --prefix=$LOCALLIB --enable-languages=c,c++,fortran,go --disable-multilib
    make
    make install
  fi
fi

### R
if [ "$RSRCINSTALL" = "TRUE" ]
then
  RSRC=R-3.5.2
  DLURLRSRC=https://cran.r-project.org/src/base/R-3/${RSRC}.tar.gz
  echo " *** Installation of $RSRC from $DLURLRSRC ..."
  cd $DOWNLOADSRC
  download_extract $RSRC $DLURLRSRC
  ### # use special prefix for R
  PREFIX=/qualstorzws01/data_projekte/linuxBin/${RSRC}
  cd ${RSRC}
  if [ "$DRYRUN" = "TRUE" ]
  then
    echo " *** DRYRUN configure;compile and install of $RSRC"
  else
    # make changes to config.site
    cp config.site config.site.org
    ### # use the libraries from $LOCALLIB to be included
    echo "CPPFLAGS=-I$LOCALLIB/include" >> config.site
    ### # use gfortran to compile f77 stuff
    echo "F77=gfortran" >> config.site
    ### # tell the linker where libgfortran can be found
    echo "LDFLAGS=-L$LOCALLIB/lib64" >> config.site
    ### # start compilation and installation
    ./configure --prefix=$PREFIX --with-readline=yes --with-x=no
    make
    make install
  fi  
fi

### # end
echo "End of $SCRIPT at: "`date`


: <<=cut
=pod


=head1 NAME

  20180419_compile_prereq_R.sh -- Shell script to download and compile R and all required tools
  

=head1 SYNOPSIS

  20180419_compile_prereq_R.sh -s <download_src_dir> -u <local_lib_dir>
  
    where: <download_src_dir>: the download source directory
           <local_lib_dir>: local library directory
           
           
=head1 DESCRIPTION

Compilation and installation of R requires certain tools. This script downloads them and compiles them. 
The collection of tools can be downloaded individually given the correct commandline options


=head1 LICENSE

Artistic License 2.0 http://opensource.org/licenses/artistic-license-2.0


=head1 AUTHOR

Peter von Rohr <peter.vonrohr@qualitasag.ch>

=cut
