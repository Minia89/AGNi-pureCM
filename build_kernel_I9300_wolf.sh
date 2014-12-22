#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_CM.sh
. ~/gcc_4.9.3_linaro_cortex-a9.sh

export ARCH=arm

if [ ! -f $KERNELDIR/.config ];
then
  make defconfig psn_i9300_new_wolfson_defconfig
fi

. $KERNELDIR/.config

mv .git .git-halt

cd $KERNELDIR/
make -j2 || exit 1

mkdir -p $KERNELDIR/BUILT_I9300_wolf/lib/modules

rm $KERNELDIR/BUILT_I9300_wolf/lib/modules/*
rm $KERNELDIR/BUILT_I9300_wolf/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT_I9300_wolf/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_I9300_wolf/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT_I9300_wolf/

mv .git-halt .git
