LOCAL_PATH      := $(call my-dir)
include $(CLEAR_VARS)

# override strip command to strip all symbols from output library; no need to ship with those..
# cmd-strip = $(TOOLCHAIN_PREFIX)strip $1 

LOCAL_ARM_MODE  := arm

LOCAL_MODULE := native_shared

LOCAL_MODULE_FILENAME := libnative

#LOCAL_MODULE    := libnative
LOCAL_CFLAGS    := -Werror
LOCAL_SRC_FILES := NativeCode.c
LOCAL_LDLIBS    := -llog
LOCAL_C_INCLUDES := $(LOCAL_PATH)

include $(BUILD_SHARED_LIBRARY)
