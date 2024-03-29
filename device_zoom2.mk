#
# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# include cicada's sensors library
common_ti_dirs := libsensors

include $(call all-named-subdir-makefiles, $(common_ti_dirs))

$(call inherit-product, build/target/product/full_base.mk)

# Place kernels to enable switching between 16 and 32 bit framebuffers
# 16 bit can be use for a large increase in GFX performance
# 32 bit is default
PRODUCT_COPY_FILES += \
    device/bn/zoom2/prebuilt/boot/kernel:/system/bin/kernel/uImage

# Get a proper init file
PRODUCT_COPY_FILES += \
    device/bn/zoom2/init.zoom2.rc:root/init.zoom2.rc \
    device/bn/zoom2/ueventd.zoom2.rc:root/ueventd.zoom2.rc

# Place wifi files
PRODUCT_COPY_FILES += \
    device/bn/zoom2/prebuilt/wifi/tiwlan_drv.ko:/system/lib/modules/tiwlan_drv.ko \
    device/bn/zoom2/prebuilt/wifi/tiwlan.ini:/system/etc/wifi/tiwlan.ini \
    device/bn/zoom2/prebuilt/wifi/firmware.bin:/system/etc/wifi/firmware.bin

# Place bluetooth firmware
PRODUCT_COPY_FILES += \
    device/bn/zoom2/firmware/TIInit_7.2.31.bts:/system/etc/firmware/TIInit_7.2.31.bts

# Place prebuilt from omapzoom
PRODUCT_COPY_FILES += \
    device/bn/zoom2/prebuilt/GFX/system/lib/:/system/lib/

# Place permission files
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

$(call inherit-product-if-exists, vendor/bn/zoom2/zoom2-vendor.mk)


DEVICE_PACKAGE_OVERLAYS += device/bn/zoom2/overlay

PRODUCT_PACKAGES += \
    librs_jni \
    tiwlan.ini \
    dspexec \
    libbridge \
    wlan_cu \
    libtiOsLib \
    wlan_loader \
    libCustomWifi \
    wpa_supplicant.conf \
    dhcpcd.conf \
    libOMX.TI.AAC.encode \
    libOMX.TI.AMR.encode \
    libOMX.TI.WBAMR.encode \
    libOMX.TI.JPEG.Encoder \
    libLCML \
    libOMX_Core \
    libOMX.TI.Video.Decoder \
    libOMX.TI.Video.encoder \
    libVendor_ti_omx \
    sensors.zoom2 \
    lights.zoom2 \
    alsa.default \
    alsa.omap3 \
    acoustics.default \
    libomap_mm_library_jni \
    hwprops

PRODUCT_PACKAGES += \
    libreference-ril

# Use medium-density artwork where available
PRODUCT_LOCALES += mdpi

# Vold
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/etc/vold.zoom2.fstab:system/etc/vold.fstab

# Media Profile
PRODUCT_COPY_FILES += \
   $(LOCAL_PATH)/etc/media_profiles.xml:system/etc/media_profiles.xml

# Misc # TODO: Find a better home for this
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/clear_bootcnt.sh:/system/bin/clear_bootcnt.sh

# update the battery log info
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/log_battery_data.sh:/system/bin/log_battery_data.sh

# SD ramdisk packer script - by request - execute manually as-needed

#PRODUCT_COPY_FILES += \
#        $(LOCAL_PATH)/sd_ramdisk_packer.sh:sd_ramdisk_packer.sh


ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/bn/zoom2/prebuilt/boot/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif


ifeq ($(TARGET_PREBUILT_BOOTLOADER),)
    LOCAL_BOOTLOADER := device/bn/zoom2/prebuilt/boot/MLO
else
    LOCAL_BOOTLOADER := $(TARGET_PREBUILT_BOOTLOADER)
endif

ifeq ($(TARGET_PREBUILT_2NDBOOTLOADER),)
    LOCAL_2NDBOOTLOADER := device/bn/zoom2/prebuilt/boot/u-boot.bin
else
    LOCAL_2NDBOOTLOADER := $(TARGET_PREBUILT_2NDBOOTLOADER)
endif


# Boot files
PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel \
    $(LOCAL_BOOTLOADER):bootloader \
    $(LOCAL_2NDBOOTLOADER):2ndbootloader

# Set property overrides
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt-flags=m=y \
    ro.com.google.locationfeatures=1 \
    ro.com.google.networklocation=1 \
    ro.allow.mock.location=1 \
    qemu.sf.lcd_density=160 \
    ro.setupwizard.enable_bypass=1 \
    ro.sf.hwrotation=270 \
    ro.setupwizard.enable_bypass=1 \
    keyguard.no_require_sim=1 \
    wifi.interface=tiwlan0 \
    alsa.mixer.playback.master=default \
    alsa.mixer.capture.master=Analog \
    dalvik.vm.heapsize=32m \
    ro.opengles.version=131072

FRAMEWORKS_BASE_SUBDIRS += \
            $(addsuffix /java, \
	    omapmmlib \
	 )

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_zoom2
PRODUCT_DEVICE := zoom2
