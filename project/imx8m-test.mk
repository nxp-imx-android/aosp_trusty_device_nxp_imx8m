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

MEMSIZE            ?= 0x2000000
KERNEL_ASPACE_BASE := 0xFFFFFFFF00000000
KERNEL_ASPACE_SIZE := 0x100000000
USER_ASPACE_BASE   := 0x0000000000008000
USER_ASPACE_SIZE   := 0x0000000001ff8000

TARGET := imx8m

include project/imx8m-test-inc.mk
