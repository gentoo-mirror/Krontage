#! /bin/bash

SCRIPTS_PATH=$(readlink -f ${0})
SCRIPTS_PATH=${SCRIPTS_PATH%/*}

EBUILD_PATH=${SCRIPTS_PATH%/*}
EBUILD_NAME=${EBUILD_PATH##*/}

version_current=$(ls -rv ${EBUILD_PATH}/${EBUILD_NAME}-* \
  |head -n1 \
  |sed -e "s,.*${EBUILD_NAME}-\(.\+\)\.ebuild,\1,")

[[ -n "${version_current}" ]] || exit

version_last=$(curl -s \
  https://github.com/telegramdesktop/tdesktop/releases \
    |grep '/telegramdesktop/tdesktop/releases/tag/' \
    |sed -e 's/<[^>]*>//g' \
    |awk '{if(NR<2){print $2}}')

[[ -n "${version_last}" ]] || exit
[[ ${version_last} == ${version_current} ]] && exit

ebuild_current=${EBUILD_PATH}/${EBUILD_NAME}-${version_current}.ebuild
ebuild_new=${EBUILD_PATH}/${EBUILD_NAME}-${version_last}.ebuild

cp -v \
  ${ebuild_current} \
  ${ebuild_new}

sudo \
  ebuild ${ebuild_new} digest || exit

git add ${ebuild_new}
git commit \
  -m "updates ${EBUILD_NAME} to ${version_last}" \
  ${ebuild_new}

git push

