ARCHS = arm64e arm64 armv7 armv7s

THEOS_DEVICE_IP = 192.168.1.3

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WAWordCopy

WAWordCopy_FILES = Tweak.xm
WAWordCopy_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk


install4::
		install4.exec
