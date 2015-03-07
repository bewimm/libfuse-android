LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := libfuse

LOCAL_SRC_FILES := $(addprefix ../lib/,buffer.c cuse_lowlevel.c fuse.c fuse_loop.c fuse_loop_mt.c fuse_lowlevel.c fuse_mt.c fuse_opt.c fuse_session.c fuse_signals.c helper.c mount.c mount_util.c )

LOCAL_C_INCLUDES        := $(addprefix $(LOCAL_PATH)/../,include)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)

# -D_FILE_OFFSET_BITS=64 doesn't actually do anything when compiling for android
# so all occurences of off_t have manually been replaced with off64_t
LOCAL_CFLAGS := -DFUSE_USE_VERSION=30
LOCAL_CFLAGS += -Wno-pointer-arith -Wno-sign-compare

LOCAL_EXPORT_CFLAGS := $(LOCAL_CFLAGS)

LOCAL_LDLIBS := -Wl,--version-script=$(LOCAL_PATH)/../lib/fuse_versionscript
LOCAL_SHARED_LIBRARIES := libc libdl

include $(BUILD_SHARED_LIBRARY)


#############################################################
# test executable
#############################################################
include $(CLEAR_VARS)
TARGET_PLATFORM := android-16
APP_PLATFORM := android-16

common_SRC_FILES := ../test/test.c

common_C_INCLUDES += \
	$(LOCAL_PATH)/ \
	$(LOCAL_PATH)/../include


LOCAL_CFLAGS += -std=c99 -fvisibility=hidden -fPIE
LOCAL_LDLIBS += -fPIE -pie
LOCAL_SRC_FILES := $(common_SRC_FILES)
LOCAL_C_INCLUDES += $(common_C_INCLUDES)
LOCAL_SHARED_LIBRARIES += fuse

LOCAL_MODULE:= fuse_test

include $(BUILD_EXECUTABLE)
