#! /bin/bash

SCRIPTS_PATH=$(readlink -f ${0})
SCRIPTS_PATH=${SCRIPTS_PATH%/*}

EBUILD_PATH=${SCRIPTS_PATH%/*}
EBUILD_NAME=${EBUILD_PATH##*/}

VERSIONS_KEEP=3

declare -a to_remove=( $(ls -rv \
  ${EBUILD_PATH}/${EBUILD_NAME}-* \
  |awk "{if(NR>${VERSIONS_KEEP}){print}}") )

rm -v ${to_remove[@]}
for e in ${EBUILD_PATH}/${EBUILD_NAME}-*.ebuild;do
  ebuild ${e} manifest
done

git commit \
  -m "versions cleanup for ${EBUILD_NAME}" \
  ${to_remove[@]} \
  ${EBUILD_PATH}/Manifest

git push

