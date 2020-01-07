# Copyright (C) 2018 The Android Open Source Project
# Copyright NXP 2018
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
KERNEL_ASPACE_BASE := 0xFFFFFFFF00000000
KERNEL_ASPACE_SIZE := 0x100000000
USER_ASPACE_BASE   := 0x0000000000008000
USER_ASPACE_SIZE   := 0x0000000001ff8000
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

GLOBAL_DEFINES += MMU_USER_SIZE_SHIFT=25 # 32 MB user-space address space

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

STORAGE_RPMB_BLOCK_COUNT ?= 256
# Set max RPMB block to 256 means it will get 256*512=128KB space to store critical information.
GLOBAL_DEFINES += APP_STORAGE_RPMB_BLOCK_COUNT=$(STORAGE_RPMB_BLOCK_COUNT)

GLOBAL_DEFINES += \
	WITH_LIB_VERSION=1 \

# ARM suggest to use system registers to access GICv3/v4 registers
GLOBAL_DEFINES += ARM_GIC_USE_SYSTEM_REG=1

#
# Modules to be compiled into lk.bin
#
MODULES += \
	lib/sm \
	lib/trusty \
	lib/memlog \

TRUSTY_USER_ARCH := arm64

#
# user tasks to be compiled into lk.bin
#

# prebuilt
TRUSTY_PREBUILT_USER_TASKS :=

# compiled from source
TRUSTY_ALL_USER_TASKS := \
	trusty/user/app/avb \
	trusty/hardware/nxp/app/hwcrypto \
	trusty/user/app/keymaster \
	trusty/user/app/gatekeeper \
	trusty/user/app/storage \

# This project requires trusty IPC
WITH_TRUSTY_IPC := true

EXTRA_BUILDRULES += app/trusty/user-tasks.mk
