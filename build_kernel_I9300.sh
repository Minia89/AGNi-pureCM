#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_CM.sh
. ~/gcc_4.7.4_linaro_cortex-a9.sh

export ARCH=arm

if [ ! -f $KERNELDIR/.config ];
then
  make defconfig psn_i9300_v2.7.1_defconfig
fi

. $KERNELDIR/.config

mv .git .git-halt

cd $KERNELDIR/
make -j2 || exit 1

mkdir -p $KERNELDIR/BUILT_I9300/lib/modules

rm $KERNELDIR/BUILT_I9300/lib/modules/*
rm $KERNELDIR/BUILT_I9300/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT_I9300/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_I9300/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT_I9300/

mv .git-halt .git
