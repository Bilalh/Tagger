#!/bin/bash
#Fixes the install path of the libraries

set -x
pwd
# space separated list of libraries
TARGETS="libtag.1.dylib"

EXECFILE=${BUILT_PRODUCTS_DIR}/${EXECUTABLE_PATH}
LIBPATH=${BUILT_PRODUCTS_DIR}/Tagger.app/Contents/Frameworks/
NEWLIBPATH="@executable_path/../Frameworks"


for TARGET in ${TARGETS} ; do
    LIBFILE=${LIBPATH}/${TARGET}
    #TARGETID=`otool -DX ${LIBPATH}/$TARGET`
    TARGETID=`otool -DX /usr/local/lib/$TARGET`
    NEWTARGETID=${NEWLIBPATH}/${TARGET}
    # On 10.9 this need sudo for some reason
    sudo install_name_tool -id ${NEWTARGETID} ${LIBFILE}
    sudo install_name_tool -change ${TARGETID} ${NEWTARGETID} ${EXECFILE}
done
set +x