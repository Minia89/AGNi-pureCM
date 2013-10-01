#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_CM.sh
. ~/gcc_4.7.2_armv7l.sh

export ARCH=arm

if [ ! -f $KERNELDIR/.config ];
then
   make defconfig psn_n7100_v2.3.3d_defconfig
fi

. $KERNELDIR/.config

mv .git .git-halt

cd $KERNELDIR/
make -j2 || exit 1

mkdir -p $KERNELDIR/BUILT_N7100/lib/modules

rm $KERNELDIR/BUILT_N7100/lib/modules/*
rm $KERNELDIR/BUILT_N7100/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT_N7100/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_N7100/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT_N7100/

mv .git-halt .git
