if [ -z "$BUILDDIR" ]; then
    echo >&2 "Error: The build directory (BUILDDIR) must be set!"
    exit 1
fi

PWD=$(pwd)
DIR=$(dirname $PWD)


#Configuring bblayers.conf

echo "BBLAYERS += \" $DIR/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
#echo "BBLAYERS += \" $DIR/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf
echo "BBLAYERS += \" $DIR/meta-mender/meta-mender-raspberrypi \"" >> conf/bblayers.conf
echo "BBLAYERS += \" $DIR/meta-raspberrypi \"" >> conf/bblayers.conf
echo "BBLAYERS += \" $DIR/meta-openembedded/meta-networking \"" >> conf/bblayers.conf
echo "BBLAYERS += \" $DIR/meta-openembedded/meta-python \"" >> conf/bblayers.conf
echo "BBLAYERS += \" $DIR/meta-openembedded/meta-oe \"" >> conf/bblayers.conf
echo "BBLAYERS += \" $DIR/meta-nodejs \"" >> conf/bblayers.conf
echo "BBLAYERS += \" $DIR/meta-himinds \"" >> conf/bblayers.conf


#configure local.conf for rashperry pi3

sed -i '/MACHINE/d' conf/local.conf

echo "MACHINE ?= \"raspberrypi3\"" >> conf/local.conf

echo "MENDER_ARTIFACT_NAME =\"release-1\"" >> conf/local.conf
echo "INHERIT += \"mender-full\"" >> conf/local.conf
# For Raspberry Pi, uncomment the following block:
echo "RPI_USE_U_BOOT = \"1\"" >> conf/local.conf
echo "MENDER_PARTITION_ALIGNMENT_KB = \"4096\"" >> conf/local.conf
echo "MENDER_BOOT_PART_SIZE_MB = \"40\"" >> conf/local.conf
echo "IMAGE_INSTALL_append = \"kernel-image kernel-devicetree\"" >> conf/local.conf
echo "IMAGE_FSTYPES_remove += \" rpi-sdimg\"" >> conf/local.conf
echo "IMAGE_FSTYPES = \"ext4\"" >> conf/local.conf
echo  "DISTRO_FEATURES_append = \" systemd\"" >> conf/local.conf
echo  "VIRTUAL-RUNTIME_init_manager = \"systemd\"" >> conf/local.conf
echo  "DISTRO_FEATURES_BACKFILL_CONSIDERED = \"sysvinit\"" >> conf/local.conf
echo  "VIRTUAL-RUNTIME_initscripts = \" \"" >> conf/local.conf

sleep 2

bitbake himinds-basic-image
