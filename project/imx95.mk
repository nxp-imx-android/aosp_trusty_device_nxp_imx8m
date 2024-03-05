# Copyright (C) 2015 The Android Open Source Project
# Copyright NXP 2023
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

TARGET := imx95

#Enlarge imx95 storage size to 2048 blocks.
STORAGE_RPMB_BLOCK_COUNT = 2048
MEMBASE           := 0x8C000000
IMX_USE_LPUART := true
SMP_MAX_CPUS := 6

# ELE support
WITH_ELE_SUPPORT := true

include project/imx8-inc.mk

GLOBAL_DEFINES += GIC600=1

GLOBAL_DEFINES += PLATFORM_USE_BGRA=1

WITH_DPU_SUPPORT := true

TRUSTY_BUILTIN_USER_TASKS += \
        trusty/hardware/nxp/app/hwsecure \
        trusty/hardware/nxp/app/secure_fb_impl \
        trusty/user/base/app/hwsecure_client \

TRUSTY_LOADABLE_USER_TASKS += \
        trusty/user/app/confirmationui

CONFIRMATIONUI_DEVICE_PARAMS := trusty/hardware/nxp/user/lib/tui_device_params
