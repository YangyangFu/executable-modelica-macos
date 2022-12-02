#!/bin/bash
#################################################
# Shell script that simulates JModelica using
# a docker image of JModelica.
#
# Author: Yangyang Fu
# Date; 2022-03-25
#################################################
set -e
DOCKER_USERNAME=passivelogic
IMG_NAME=benchmark
IMG_TAG=jmodelica

# Get root 
echo "Bash version ${BASH_VERSION}...."
LIBRARY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Direct to the top folder where the library is. For this case xxx/quantum-system-benchmark
LIBRARY_LEVEL=2
for ((l=1; l<=$LIBRARY_LEVEL; l++))
do 
	echo "$l"
	LIBRARY_DIR=$(dirname $LIBRARY_DIR)
done

# Specify modelica testing folder in the docker and 
# mount given local folder to this testing folder when runing docker 
MODELICATEST_PATH=/home/developer/modelica_test

# If the current directory is part of the argument list,
# replace it with . as the docker may have a different file structure
cur_dir=`pwd`
bas_nam=`basename ${cur_dir}`
arg_lis=`echo $@ | sed -e "s|${cur_dir}|.|g"`

# Set variable for shared directory
sha_dir=`dirname ${cur_dir}`

# Check if the python script should be run interactively (if -i is specified)
while [ $# -ne 0 ]
do
    arg="$1"
    case "$arg" in
        -i)
            interactive=true
            DOCKER_INTERACTIVE=-t
            ;;
    esac
    shift
done

docker run \
  -i \
  $DOCKER_INTERACTIVE \
  --detach=false \
  -v ${sha_dir}:/mnt/shared \
  -v ${LIBRARY_DIR}:${MODELICATEST_PATH} \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --rm \
  ${DOCKER_USERNAME}/${IMG_NAME}:${IMG_TAG} /bin/bash -c \
  "cd /mnt/shared/${bas_nam} && \
  export MODELICAPATH=${MODELICATEST_PATH}/benchmarkpy/tests:\$MODELICAPATH && \
  /usr/local/JModelica/bin/jm_python.sh ${arg_lis}"
exit $?