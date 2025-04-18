#!/bin/sh -e
green="\e[0;32m"
red="\e[0;31m"
blue="\e[0;34m"
end_color="\e[0m"

GIT_URL="https://github.com/scpcom/riscv-gnu-toolchain"
GIT_DEF="xuantie-gnu-toolchain-v2.8.x"

[ "X$GIT_REF" = "X" ] && GIT_REF="${GIT_DEF}"

BUILDDIR="/opt/gnu"

for v in csky thead xuantie ; do
  if echo "${GIT_REF}" | grep -q $v ; then
    BUILDDIR="/opt/$v"
    break
  fi
done

SCRIPTDIR=`pwd`

if [ "X$LIBC_SHORT" = "X" ]; then
echo "${red}LIBC_SHORT is not set${end_color}"
exit 1
fi

[ "X$TARGET_MACH" = "X" ] && TARGET_MACH="riscv64"
[ "X$HOST_MACH" = "X" ] && HOST_MACH=`uname -m`

echo "${blue}Target: ${TARGET_MACH}${end_color}"
echo "${blue}LibC: ${LIBC_SHORT}${end_color}"
echo "${blue}Host: ${HOST_MACH}${end_color}"

bs=${BUILDDIR}/sdk-prepare-checkout-stamp
if [ ! -e $bs ]; then
  echo "\n${green}Checking out SDK for ${LIBC_SHORT}${end_color}\n"
  mkdir -p ${BUILDDIR}
  git clone -b ${GIT_DEF} ${GIT_URL} ${BUILDDIR}/toolchain
  cd ${BUILDDIR}/toolchain && git checkout ${GIT_REF}
  cd ${BUILDDIR}/toolchain && git rm -r qemu
  cd ${BUILDDIR}/toolchain && git submodule update --init --recursive --depth=1
  touch ${BUILDDIR}/xuantie-gnu-toolchain-submodule-source.tar.gz
  touch $bs
fi

bs=${BUILDDIR}/sdk-prepare-patch-stamp
if [ ! -e $bs ]; then
  echo "\n${green}Patching SDK for ${LIBC_SHORT}${end_color}\n"
  for f in ${SCRIPTDIR}/*.sh ; do
    b=`basename $f`
    if [ -e $f -a ! -e ${BUILDDIR}/$b ]; then
      cp -p $f ${BUILDDIR}/
    fi
  done
  #cd ${BUILDDIR} && ./prepare-host.sh
  cd ${BUILDDIR}/toolchain && git apply ${SCRIPTDIR}/toolchain-cleanup-after-build.patch
  rm -rf ${BUILDDIR}/toolchain/.git
  touch $bs
fi

bs=${BUILDDIR}/sdk-compile-stamp
if [ ! -e $bs ]; then
  echo "\n${green}Building SDK for ${LIBC_SHORT}${end_color}\n"
  cd ${BUILDDIR} && ./build-riscv-thead-${LIBC_SHORT}-toolchain.sh
  touch $bs
fi

bs=${BUILDDIR}/sdk-output-stamp
if [ ! -e $bs ]; then
  echo "\n${green}Packing Toolchain for ${LIBC_SHORT}${end_color}\n"
  rm -f ${BUILDDIR}/xuantie-gnu-toolchain-submodule-source.tar.gz
  t=missing
  for f in ${BUILDDIR}/riscv*.tar.?z ; do
    [ -e $f ] || continue
    cp -p $f /output/
    t=`basename $f`
    break
  done
  echo "\n${green}Toolchain for ${LIBC_SHORT} is ${t}${end_color}\n"
  touch $bs
fi
