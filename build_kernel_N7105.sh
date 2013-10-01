#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_CM.sh
. ~/gcc_4.7.2_armv7l.sh

export ARCH=arm

if [ ! -f $KERNELDIR/.config ];
then
   make defconfig cyanogenmod_t0lte_defconfig
fi

. $KERNELDIR/.config

mv .git .git-halt

cd $KERNELDIR/
make -j2 || exit 1

mkdir -p $KERNELDIR/BUILT_N7105/lib/modules

rm $KERNELDIR/BUILT_N7105/lib/modules/*
rm $KERNELDIR/BUILT_N7105/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT_N7105/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_N7105/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT_N7105/

mv .git-halt .git

