Start=$(date +"%s")
yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
KERNEL_DIR=$PWD
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/anderson/toolchain/google-android-4.9/bin/aarch64-linux-android-"
export LD_LIBRARY_PATH=home/anderson/toolchain/google-android-4.9/lib/
STRIP="/home/anderson/toolchain/google-android-4.9/bin/aarch64-linux-android-strip"
make clean
make cyanogenmod_kenzo_defconfig
export KBUILD_BUILD_HOST="iMac"
export KBUILD_BUILD_USER="AndersonAragao"
make -j4
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/output/files/dt.img
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/output/files/Image
rm -rf $KEREL_DIR/output/system
mkdir -p $KERNEL_DIR/output/system/lib/modules
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/output/system/lib/modules/wlan.ko
cd $KERNEL_DIR/output
rm *.zip
cd $KERNEL_DIR/output/system/lib/modules/
$STRIP --strip-unneeded *.ko
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red<<Failed to compile Kernel Image, fix the issues first>>$white"
else
cd $KERNEL_DIR/output
zip -r NX-MIUI-Kernel-RN3Pro.zip *
fi
cd $KERNEL_DIR
