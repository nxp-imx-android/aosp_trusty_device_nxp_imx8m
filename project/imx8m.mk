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

TARGET := imx8m

STORAGE_RPMB_BLOCK_COUNT := 2048
MEMBASE           := 0xFE000000

WITH_SNVS_DRIVER := true

# caam support
WITH_CAAM_SUPPORT := true

# customized secure ui support
WITH_CUSTOMIZED_SECURE_UI := false

include project/imx8-inc.mk

TRUSTY_PROVISIONING_METHOD := OEMCrypto_Keybox

ifeq (true,$(call TOBOOL,$(BUILD_WIDEVINE)))
TRUSTY_LOADABLE_USER_TASKS += \
    trusty/private/oemcrypto/oemcrypto/opk/ports/trusty/ta/reference

NEED_PARSE_HEADER := true
endif

WITH_VPU_DECODER_DRIVER := true
WITH_VPU_ENCODER_DRIVER := false

TRUSTY_BUILTIN_USER_TASKS += \
    trusty/hardware/nxp/app/secure_fb_impl \
    trusty/hardware/nxp/app/hwsecure \
    trusty/user/base/app/hwsecure_client \

TRUSTY_LOADABLE_USER_TASKS += \
    trusty/user/app/confirmationui

WITH_DCSS_SUPPORT := true

CONFIRMATIONUI_DEVICE_PARAMS := trusty/hardware/nxp/user/lib/tui_device_params
