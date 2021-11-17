#!/bin/bash -e

# PWD = source dir
# BASE_DIR = build dir
# BUILD_DIR = base dir/build
# HOST_DIR = base dir/host
# BINARIES_DIR = images dir
# TARGET_DIR = target dir

##### constants ################
RETROLX_BINARIES_DIR="${BINARIES_DIR}/retrolx"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
################################

##### find images to build #####
RETROLX_TARGET=$(grep -E "^BR2_PACKAGE_RETROLX_TARGET_[A-Z_0-9]*=y$" "${BR2_CONFIG}" | grep -vE "_ANY=" | sed -e s+'^BR2_PACKAGE_RETROLX_TARGET_\([A-Z_0-9]*\)=y$'+'\1'+)
RETROLX_LOWER_TARGET=$(echo "${RETROLX_TARGET}" | tr [A-Z] [a-z])
RETROLX_IMAGES_TARGETS=$(grep -E "^BR2_TARGET_RETROLX_IMAGES[ ]*=[ ]*\".*\"[ ]*$" "${BR2_CONFIG}" | sed -e s+"^BR2_TARGET_RETROLX_IMAGES[ ]*=[ ]*\"\(.*\)\"[ ]*$"+"\1"+)
if test -z "${RETROLX_IMAGES_TARGETS}"
then
    echo "no BR2_TARGET_RETROLX_IMAGES defined." >&2
    exit 1
fi
################################

#### common parent dir to al images #
if echo "${RETROLX_IMAGES_TARGETS}" | grep -qE '^[^ ]*$'
then
    # single board directory
    IMGMODE=single
else
    # when there are several one, the first one is the common directory where to find the create-boot-script.sh directory
    IMGMODE=multi
fi

#### clean the (previous if exists) target directory ###
if test -d "${RETROLX_BINARIES_DIR}"
then
    rm -rf "${RETROLX_BINARIES_DIR}" || exit 1
fi
mkdir -p "${RETROLX_BINARIES_DIR}/images" || exit 1

##### build images #############
SUFFIXVERSION=$(cat "${TARGET_DIR}/usr/share/retrolx/retrolx.version" | sed -e s+'^\([0-9\.]*\).*$'+'\1'+) # xx.yy version
SUFFIXDATE=$(date +%Y%m%d)

#### build the images ###########
for RETROLX_PATHSUBTARGET in ${RETROLX_IMAGES_TARGETS}
do
    RETROLX_SUBTARGET=$(basename "${RETROLX_PATHSUBTARGET}")

    #### prepare the boot dir ######
    BOOTNAMEDDIR="${RETROLX_BINARIES_DIR}/boot_${RETROLX_SUBTARGET}"
    rm -rf "${BOOTNAMEDDIR}" || exit 1 # remove in case or rerun
    RETROLX_POST_IMAGE_SCRIPT="${BR2_EXTERNAL_RETROLX_PATH}/board/retrolx/${RETROLX_PATHSUBTARGET}/create-boot-script.sh"
    bash "${RETROLX_POST_IMAGE_SCRIPT}" "${HOST_DIR}" "${BR2_EXTERNAL_RETROLX_PATH}/board/retrolx/${RETROLX_PATHSUBTARGET}" "${BUILD_DIR}" "${BINARIES_DIR}" "${TARGET_DIR}" "${RETROLX_BINARIES_DIR}" || exit 1
    cp     "${BINARIES_DIR}/retrolx-boot.conf" "${RETROLX_BINARIES_DIR}/boot/" || exit 1
    echo   "${RETROLX_SUBTARGET}" > "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.board" || exit 1

    #### boot.tar.xz ###############
    #echo "creating images/${RETROLX_SUBTARGET}/boot.tar.xz"
    mkdir -p "${RETROLX_BINARIES_DIR}/images/${RETROLX_SUBTARGET}" || exit 1
    #(cd "${RETROLX_BINARIES_DIR}/boot" && tar -I "xz -T0" -cf "${RETROLX_BINARIES_DIR}/images/${RETROLX_SUBTARGET}/boot.tar.xz" *) || exit 1
    
    # rename the squashfs : the .update is the version that will be renamed at boot to replace the old version
    mv "${RETROLX_BINARIES_DIR}/boot/boot/batocera.update" "${RETROLX_BINARIES_DIR}/boot/boot/batocera" || exit 1

    # create *.img
    if test "${IMGMODE}" = "multi"
    then
	RETROLXIMG="${RETROLX_BINARIES_DIR}/images/${RETROLX_SUBTARGET}/retrolx-${RETROLX_LOWER_TARGET}-${RETROLX_SUBTARGET}-${SUFFIXVERSION}-${SUFFIXDATE}.img"
    else
	RETROLXIMG="${RETROLX_BINARIES_DIR}/images/${RETROLX_SUBTARGET}/retrolx-${RETROLX_LOWER_TARGET}-${SUFFIXVERSION}-${SUFFIXDATE}.img"
    fi
    echo "creating images/${RETROLX_SUBTARGET}/"$(basename "${RETROLXIMG}")"..." >&2
    rm -rf "${GENIMAGE_TMP}" || exit 1
    GENIMAGEDIR="${BR2_EXTERNAL_RETROLX_PATH}/board/retrolx/${RETROLX_PATHSUBTARGET}"
    GENIMAGEFILE="${GENIMAGEDIR}/genimage.cfg"
    FILES=$(find "${RETROLX_BINARIES_DIR}/boot" -type f | sed -e s+"^${RETROLX_BINARIES_DIR}/boot/\(.*\)$"+"file \1 \{ image = '\1' }"+ | tr '\n' '@')
    cat "${GENIMAGEFILE}" | sed -e s+'@files'+"${FILES}"+ | tr '@' '\n' > "${RETROLX_BINARIES_DIR}/genimage.cfg" || exit 1

    # install syslinux
    if grep -qE "^BR2_TARGET_SYSLINUX=y$" "${BR2_CONFIG}"
    then
	GENIMAGEBOOTFILE="${GENIMAGEDIR}/genimage-boot.cfg"
	echo "installing syslinux" >&2
	cat "${GENIMAGEBOOTFILE}" | sed -e s+'@files'+"${FILES}"+ | tr '@' '\n' > "${RETROLX_BINARIES_DIR}/genimage-boot.cfg" || exit 1
    genimage --rootpath="${TARGET_DIR}" --inputpath="${RETROLX_BINARIES_DIR}/boot" --outputpath="${RETROLX_BINARIES_DIR}" --config="${RETROLX_BINARIES_DIR}/genimage-boot.cfg" --tmppath="${GENIMAGE_TMP}" || exit 1
    "${HOST_DIR}/bin/syslinux" -i "${RETROLX_BINARIES_DIR}/boot.vfat" -d "/boot/syslinux" || exit 1
    #"/usr/bin/syslinux" -i "${RETROLX_BINARIES_DIR}/boot.vfat" -d "/boot/syslinux" || exit 1
    # remove genimage temp path as sometimes genimage v14 fails to start
    rm -rf ${GENIMAGE_TMP}
    mkdir ${GENIMAGE_TMP}
    fi
    ###
    "${HOST_DIR}/bin/genimage" --rootpath="${TARGET_DIR}" --inputpath="${RETROLX_BINARIES_DIR}/boot" --outputpath="${RETROLX_BINARIES_DIR}" --config="${RETROLX_BINARIES_DIR}/genimage.cfg" --tmppath="${GENIMAGE_TMP}" || exit 1
 
    rm -f "${RETROLX_BINARIES_DIR}/boot.vfat" || exit 1
    rm -f "${RETROLX_BINARIES_DIR}/userdata.ext4" || exit 1
    mv "${RETROLX_BINARIES_DIR}/batocera.img" "${RETROLXIMG}" || exit 1
    gzip "${RETROLXIMG}" || exit 1

    # rename the boot to boot_arch
    mv "${RETROLX_BINARIES_DIR}/boot" "${BOOTNAMEDDIR}" || exit 1

    # copy the version file needed for version check
    cp "${TARGET_DIR}/usr/share/retrolx/retrolx.version" "${RETROLX_BINARIES_DIR}/images/${RETROLX_SUBTARGET}" || exit 1

    # copy the board files
    cp "${BOOTNAMEDDIR}/boot/retrolx.board" "${RETROLX_BINARIES_DIR}/images/${RETROLX_SUBTARGET}" || exit 1
    cp "${BR2_EXTERNAL_RETROLX_PATH}/board/retrolx/${RETROLX_PATHSUBTARGET}/board.png" "${RETROLX_BINARIES_DIR}/images/${RETROLX_SUBTARGET}" || exit 1
done

#### md5 #######################
for FILE in "${RETROLX_BINARIES_DIR}/images/"*"/retrolx-"*".img.gz"
do
    echo "creating ${FILE}.md5"
    CKS=$(md5sum "${FILE}" | sed -e s+'^\([^ ]*\) .*$'+'\1'+)
    echo "${CKS}" > "${FILE}.md5"
    echo "${CKS}  $(basename "${FILE}")" >> "${RETROLX_BINARIES_DIR}/MD5SUMS"
done

#### update the target dir with some information files
cp "${TARGET_DIR}/usr/share/retrolx/retrolx.version" "${RETROLX_BINARIES_DIR}" || exit 1
