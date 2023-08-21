# Copyright (C) 2015 The Android Open Source Project
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

TARGET := imx8q

# imx8q/x use lpuart for UART IP
IMX_USE_LPUART := true

SMP_MAX_CPUS := 6
STORAGE_RPMB_BLOCK_COUNT := 2048
MEMBASE           := 0xFE000000

# caam support
WITH_CAAM_SUPPORT := true
WITH_SCFW_DRIVER := true
WITH_AMPHION_DRIVER := true

include project/imx8-inc.mk

GLOBAL_DEFINES += IMX8QM=1

TRUSTY_BUILTIN_USER_TASKS += \
    trusty/hardware/nxp/app/hwsecure \
    trusty/user/base/app/hwsecure_client \
    trusty/hardware/nxp/app/firmware_loader \

ifeq (true,$(call TOBOOL,$(BUILD_WIDEVINE)))
WTPI_BUILD_INFO := TRUSTY_IMX8

WIDEVINE_PROVISION_METHOD := 2

TRUSTY_LOADABLE_USER_TASKS += \
    trusty/private/oemcrypto/oemcrypto/opk/ports/trusty/ta
endif

