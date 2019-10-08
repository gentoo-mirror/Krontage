#! /bin/bash

SCRIPTS_PATH=$(readlink -f ${0})
SCRIPTS_PATH=${SCRIPTS_PATH%/*}

EBUILD_PATH=${SCRIPTS_PATH%/*}
EBUILD_NAME=${EBUILD_PATH##*/}

VERSIONS_KEEP=5

ls -rv \
  ${EBUILD_PATH}/${EBUILD_NAME}-* \
    |awk "{if(NR>${VERSIONS_KEEP}){print}}" \
    |xargs -I{} bash -c "\
      rm -v {} \
      && git commit -m \"version cleanup for ${EBUILD_NAME}\" {}"

git push

