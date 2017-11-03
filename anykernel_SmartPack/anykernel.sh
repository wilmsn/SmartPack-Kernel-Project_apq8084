#
# SmartPack-Kernel (AnyKernel) Script for aosp Roms
#
# Credits: osm0sis @ xda-developers
#
# Modified by sunilpaulmathew@xda-developers.com
#

## AnyKernel setup
# begin properties
properties() {
kernel.string=SmartPack Kernel by sunilpaulmathew@xda-developers.com
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=lentislte
device.name2=lentisltexxx
device.name3=lentislteskt
device.name4=lentisltektt
device.name5=lentisltelgt
device.name6=kccat6xx
device.name7=kccat6
device.name8=
device.name9=
device.name10=
device.name11=
device.name12=
device.name13=
device.name14=
device.name15=
} # end properties

# shell variables
block=/dev/block/platform/msm_sdcc.1/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files

## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc

# init.tuna.rc

# init.superuser.rc

# fstab.tuna

# end ramdisk changes

write_boot;

## end install

