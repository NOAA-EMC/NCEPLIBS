#!/bin/bash

set -e

display_usage() {
  echo "This script must be run with 4 arguments"
  echo -e "\nUsage:\ndeploy_modulefiles.sh nceplibsBuildDir nceplibsInstallDir modulesTmplDir modulesDestDir\n"
  echo -e "  nceplibsBuildDir - build directory of umbrella NCEPLIBS"
  echo -e "nceplibsInstallDir - installation location of NCEPLIBS"
  echo -e "    modulesTmplDir - location of templated NCEPLIBS modulefiles"
  echo -e "    modulesDestDir - final location of NCEPLIBS modulefiles"
  }

if [[ $# -lt 4 ]]; then
  display_usage
  exit 1
fi

nceplibsBuildDir=$1
nceplibsInstallDir=$2
modulesTmplDir=$3
modulesDestDir=$4

# Copy templates to final resting place
if [[ -d $modulesDestDir ]]; then
  echo "$modulesDestDir already exists."
  echo "cannot overwrite, ABORT!"
  exit 1
fi
cp -R $modulesTmplDir $modulesDestDir

# sed does not like delimiter (/) to be a part of replacement string
# so do magic
repl=$(echo ${nceplibsInstallDir} | sed -e "s#/#\\\/#g")

# Replace templated nceplibs installation path with actual
cd $modulesDestDir
for i in $(ls -1); do
  echo "filling template of ... $i"
  cd $i
  sed -i "s/@NCEPLIBS_ROOT@/${repl}/g" $i.lua
  version=$(cat $nceplibsBuildDir/$i/src/$i/VERSION)
  mv $i.lua ${version}.lua
  cd ..
done
