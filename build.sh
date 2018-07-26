#!/bin/bash

set -e

KERNEL_DIR=$PWD
KERNEL_TOOLCHAIN=~/arm-linux-gnueabi/bin/arm-linux-gnueabi-
KERNEL_DEFCONFIG=osprey_defconfig
JOBS=10
ANY_KERNEL2_DIR=~/Anykernel2/
DATE=$(date +"%d%m%Y")
FINAL_KERNEL_ZIP=Paradox-R1-"$DATE"-Osprey.zip

echo ">>>>>>>>>>Cleaning<<<<<<<<<<"
make clean && make mrproper

echo ">>>>>>>>>>Prebuild export Setups<<<<<<<<<<"
export CROSS_COMPILE=$KERNEL_TOOLCHAIN
export ARCH=arm
export KBUILD_BUILD_USER="@k$h@y"
export KBUILD_BUILD_HOST="Jarvis"
export USE_CCACHE=1

echo ">>>>>>>>>> Kernel defconfig is set to $KERNEL_DEFCONFIG <<<<<<<<<<<<"
make $KERNEL_DEFCONFIG
make -j$JOBS


echo ">>>>>>>>>>> Verify zImage,dtb & wlan <<<<<<<<<<<"
ls $KERNEL_DIR/arch/arm/boot/zImage
ls $KERNEL_DIR/drivers/staging/prima/wlan.ko

echo ">>>>>>>>>>> Verifying Anyernel2 Directory <<<<<<<<<<<<"
ls $ANY_KERNEL2_DIR
echo ">>>>>>>>>>>> Removing leftovers <<<<<<<<<<<<"
rm -rf $ANY_KERNEL2_DIR/zImage
rm -rf $ANY_KERNEL2_DIR/modules/system/lib/modules/wlan.ko
rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP

echo ">>>>>>>>>>> Copying zImage and modules <<<<<<<<<<<<"
mv $KERNEL_DIR/arch/arm/boot/zImage $ANY_KERNEL2_DIR/
mv $KERNEL_DIR/drivers/staging/prima/wlan.ko $ANY_KERNEL2_DIR/modules/system/lib/modules/

echo ">>>>>>>>>>> Making Anykernel zip <<<<<<<<<<<"
cd $ANY_KERNEL2_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
rm -rf ~/Paradox Release/$FINAL_KERNEL_ZIP
cp ~/Anykernel2/$FINAL_KERNEL_ZIP ~/Paradox Release/$FINAL_KERNEL_ZIP

echo ">>>>>>>>>>> Cleaning leftovers <<<<<<<<<<<<"
cd $ANY_KERNEL2_DIR
rm -rf $FINAL_KERNEL_ZIP
rm -rf zImage
