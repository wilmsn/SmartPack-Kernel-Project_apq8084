#!/bin/bash

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[1;32m"
COLOR_NEUTRAL="\033[0m"

echo -e $COLOR_GREEN"\n SmartPack-Kernel Build Script\n"$COLOR_NEUTRAL
#
echo -e $COLOR_GREEN"\n (c) sunilpaulmathew@xda-developers.com\n"$COLOR_NEUTRAL

# Toolchains

GOOGLE="/home/sunil/android-ndk-r15c/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-"

UBERTC="/home/sunil/UBERTC-arm-eabi-8.0/bin/arm-linux-androideabi-"

LINARO="/home/sunil/arm-linux-androideabi-7.x-linaro/bin/arm-linaro-linux-androideabi-"

TOOLCHAIN="linaro"	# Leave empty for using Google’s stock toolchain

ARCHITECTURE="arm"

KERNEL_NAME="SmartPack-Kernel"

KERNEL_VARIANT="lentislte"	# only one variant at a time

KERNEL_VERSION="stable-v5_r2"   # leave as such, if no specific version tag

KERNEL_DATE="$(date +"%Y%m%d")"

COMPILE_DTB="n"

NUM_CPUS=""   # number of cpu cores used for build (leave empty for auto detection)

export ARCH=$ARCHITECTURE

if [ -z "$TOOLCHAIN" ]; then
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME v. $KERNEL_VERSION for $KERNEL_VARIANT using Google's stock toolchain\n"$COLOR_NEUTRAL
	export CROSS_COMPILE="${CCACHE} $GOOGLE"
else
	if [ "ubertc" == "$TOOLCHAIN" ]; then
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME v. $KERNEL_VERSION for $KERNEL_VARIANT using UBERTC-8.x\n"$COLOR_NEUTRAL
		export CROSS_COMPILE="${CCACHE} $UBERTC"
	else
		if [ "linaro" == "$TOOLCHAIN" ]; then
		echo -e $COLOR_GREEN"\n building $KERNEL_NAME v. $KERNEL_VERSION for $KERNEL_VARIANT using Linaro-7.x toolchain\n"$COLOR_NEUTRAL
			export CROSS_COMPILE="${CCACHE} $LINARO"
		fi
	fi
fi

if [ -z "$NUM_CPUS" ]; then
	NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
fi

if [ -z "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n Please select the variant to build... KERNEL_VARIANT should not be empty...\n"$COLOR_NEUTRAL
fi

if [ "lentislte" == "$KERNEL_VARIANT" ]; then
	if [ -e output_kor/.config ]; then
		rm -f output_kor/.config
		if [ -e output_kor/arch/arm/boot/zImage ]; then
			rm -f output_kor/arch/arm/boot/zImage
		fi
	else
		mkdir output_kor
	fi
	make -C $(pwd) O=output_kor VARIANT_DEFCONFIG=apq8084_sec_lentislte_skt_defconfig apq8084_sec_defconfig SELINUX_DEFCONFIG=selinux_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_kor
	if [ -e output_kor/arch/arm/boot/zImage ]; then
		# Copying “zImage” to “anykernel” directory
		cp output_kor/arch/arm/boot/zImage anykernel_SmartPack/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_kor/arch/arm/boot/dt.img ]; then
				rm -f output_kor/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_kor/arch/arm/boot/dt.img -s 2048 -p output_kor/scripts/dtc/ output_kor/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f anykernel_SmartPack/dtb ]; then
				rm -f anykernel_SmartPack/dtb
			fi
		fi
		# generating recovery flashable zip file
		cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
		# cleaning...
		rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
		echo -e $COLOR_GREEN"\n everything done... please visit "release_SmartPack"...\n"$COLOR_NEUTRAL
	else
		echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
	fi
fi

if [ "kccat6" == "$KERNEL_VARIANT" ]; then
	if [ -e output_eur/.config ]; then
		rm -f output_eur/.config
		if [ -e output_eur/arch/arm/boot/zImage ]; then
			rm -f output_eur/arch/arm/boot/zImage
		fi
	else
		mkdir output_eur
	fi

	make -C $(pwd) O=output_eur VARIANT_DEFCONFIG=apq8084_sec_kccat6_eur_defconfig apq8084_sec_defconfig SELINUX_DEFCONFIG=selinux_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_eur
	if [ -e output_kor/arch/arm/boot/zImage ]; then
		# Copying “zImage” to “anykernel” directory
		cp output_eur/arch/arm/boot/zImage anykernel_SmartPack/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_eur/arch/arm/boot/dt.img ]; then
				rm -f output_eur/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_eur/arch/arm/boot/dt.img -s 2048 -p output_eur/scripts/dtc/ output_eur/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f anykernel_SmartPack/dtb ]; then
				rm -f anykernel_SmartPack/dtb
			fi
		fi
		# generating recovery flashable zip file
		cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
		# cleaning...
		rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
		echo -e $COLOR_GREEN"\n everything done... please visit "release_SmartPack"...\n"$COLOR_NEUTRAL
	else
		echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
	fi
fi
