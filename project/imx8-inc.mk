# Copyright (C) 2018 The Android Open Source Project
# Copyright 2018 NXP
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

LOCAL_DIR := $(GET_LOCAL_DIR)

DEBUG := 1
WITH_SMP := 1
SMP_MAX_CPUS ?= 4
SMP_CPU_CLUSTER_SHIFT ?= 2

ifeq (false,$(call TOBOOL,$(KERNEL_32BIT)))
MEMSIZE            ?= 0x2000000
MEMBASE           ?= 0xFE000000
ifeq (true, $(call TOBOOL,$(WITH_AMPHION_DRIVER)))
KERNEL_ASPACE_BASE := 0xFFFFFFF000000000
KERNEL_ASPACE_SIZE := 0x1000000000
else
KERNEL_ASPACE_BASE := 0xFFFFFFFF00000000
KERNEL_ASPACE_SIZE := 0x100000000
endif
USER_ASPACE_BASE   := 0x0000000000008000
USER_ASPACE_SIZE   := 0x00000000F0000000
ARCH := arm64
else
KERNEL_BASE       := 0xFE000000
MEMBASE           := 0xFE000000
MEMSIZE           := 0x2000000
ARCH := arm
endif

ifeq (true,$(call TOBOOL,$(BOOT_FROM_A72)))
GLOBAL_DEFINES += \
	WITH_BOOT_FROM_A72=1
endif

GIC_VERSION := 3

ARM_CPU ?= armv8-a

WITH_LIB_SM_MONITOR := 0
WITH_VIRT_TIMER_INIT := 0

ARM_MERGE_FIQ_IRQ := true

# In imx8, the TZASC will he handled by SPL or ATF
WITH_TZASC := false

#GLOBAL_DEFINES += MMU_USER_SIZE_SHIFT=25 # 32 MB user-space address space

GLOBAL_DEFINES += TIMER_ARM_GENERIC_SELECTED=CNTPS

# requires linker GC
WITH_LINKER_GC := 1

# Need support for Non-secure memory mapping
WITH_NS_MAPPING := true

# do not relocate kernel in physical memory
GLOBAL_DEFINES += WITH_NO_PHYS_RELOCATION=1

# limit heap grows
GLOBAL_DEFINES += HEAP_GROW_SIZE=0x400000

# limit physical memory to 38 bit to prevert tt_trampiline from getting larger than arm64_kernel_translation_table
GLOBAL_DEFINES += MMU_IDENT_SIZE_SHIFT=38

# enable LTO in user-tasks modules
USER_LTO_ENABLED ?= true

# enable LTO in kernel modules
KERNEL_LTO_ENABLED ?= true

# enable cfi in trusty modules
USER_CFI_ENABLED ?= true
KERNEL_CFI_ENABLED ?= true

ifeq ($(shell expr $(DEBUG) \>= 2), 1)
CFI_DIAGNOSTICS ?= true
endif

# disable UBSan by default
UBSAN_ENABLED ?= false
ifeq (true,$(call TOBOOL,$(UBSAN_ENABLED)))
include trusty/kernel/lib/ubsan/enable.mk
endif

ifeq (false,$(call TOBOOL,$(KERNEL_32BIT)))
KERNEL_SCS_ENABLED ?= true
ifeq (false,$(call TOBOOL,$(USER_32BIT)))
# enable shadow call stack in user-tasks modules
USER_SCS_ENABLED ?= true
endif
endif

# fall back to user-space stack protector if user-space SCS is off
ifneq (true,$(call TOBOOL,$(USER_SCS_ENABLED)))
USER_STACK_PROTECTOR ?= true
endif

STORAGE_RPMB_BLOCK_COUNT ?= 256
# Set max RPMB block to 256 means it will get 256*512=128KB space to store critical information.
GLOBAL_DEFINES += APP_STORAGE_RPMB_BLOCK_COUNT=$(STORAGE_RPMB_BLOCK_COUNT)

# Set the whole rpmb storage size as 8192 blocks which is 8192*512=4MB for i.MX 8.
GLOBAL_DEFINES += STORAGE_TOTAL_RPMB_BLOCK_COUNT=8192

GLOBAL_DEFINES += \
	WITH_LIB_VERSION=1 \

# uncomment this to enable rpmb storage erase option, note this option should only be used for developer
#GLOBAL_DEFINES += \
#	SUPPORT_ERASE_RPMB=1

# ARM suggest to use system registers to access GICv3/v4 registers
GLOBAL_DEFINES += ARM_GIC_USE_SYSTEM_REG=1

# include software implementation of a SPI loopback device
WITH_SW_SPI_LOOPBACK ?= true

# CAAM support
WITH_CAAM_SUPPORT ?= false

# ELE support
WITH_ELE_SUPPORT ?= false

#
# Modules to be compiled into lk.bin
#
MODULES += \
	trusty/kernel/lib/sm \
	trusty/kernel/lib/trusty \
	trusty/kernel/lib/memlog \
	trusty/kernel/services/smc \
	trusty/kernel/services/apploader \
	trusty/kernel/services/hwrng \

TRUSTY_USER_ARCH := arm64

#
# user tasks to be compiled into lk.bin
#

# prebuilt
TRUSTY_PREBUILT_USER_TASKS :=

# compiled from source
ifeq (true,$(call TOBOOL,$(BUILD_MATTER)))
TRUSTY_BUILTIN_USER_TASKS := \
	trusty/hardware/nxp/app/hwcrypto \
	trusty/user/app/storage
else
TRUSTY_BUILTIN_USER_TASKS := \
	trusty/user/app/avb \
	trusty/hardware/nxp/app/hwcrypto \
	trusty/user/app/keymint/app \
	trusty/user/app/gatekeeper \
	trusty/user/base/app/apploader \
	trusty/user/app/storage \
	trusty/user/base/app/system_state_server_static \
	trusty/user/app/sample/hwbcc \

endif

APPLOADER_ALLOW_NS_CONNECT := true

PROJECT_KEYS_DIR := trusty/device/nxp/imx8/project/keys

APPLOADER_SIGN_PRIVATE_KEY_0_FILE := \
	$(PROJECT_KEYS_DIR)/privateKey0.der

APPLOADER_SIGN_PUBLIC_KEY_0_FILE := \
	$(PROJECT_KEYS_DIR)/publicKey0.der

APPLOADER_SIGN_PRIVATE_KEY_1_FILE := \
	$(PROJECT_KEYS_DIR)/privateKey1.der

APPLOADER_SIGN_PUBLIC_KEY_1_FILE := \
	$(PROJECT_KEYS_DIR)/publicKey1.der

APPLOADER_ENCRYPT_KEY_0_FILE := \
	$(PROJECT_KEYS_DIR)/aeskey0.bin

APPLOADER_ENCRYPT_KEY_1_FILE := \
	$(PROJECT_KEYS_DIR)/aeskey1.bin

APPLOADER_SIGN_KEY_ID ?= 0

# This project requires trusty IPC
WITH_TRUSTY_IPC := true

# Set the storage service port to STORAGE_CLIENT_TP_PORT
# to support factory reset protection.
GATEKEEPER_STORAGE_PORT := STORAGE_CLIENT_TP_PORT

# Allow provisioning at boot stage.
# This flag should be set to "0" in production.
STATIC_SYSTEM_STATE_FLAG_PROVISIONING_ALLOWED := 2

TRUSTY_KM_WITH_HWWSK_SUPPORT := false

# Build unittests.
ifeq (true,$(call TOBOOL,$(BUILD_UNITTEST)))
# include both the kerneltests and usertests may make the bootloader exceed
# the size limits (4MB), make the kerneltests as disabled by default, users
# need to enable it manually.
#include trusty/kernel/kerneltests-inc.mk
include trusty/user/base/usertests-inc.mk
endif

EXTRA_BUILDRULES += trusty/kernel/app/trusty/user-tasks.mk
