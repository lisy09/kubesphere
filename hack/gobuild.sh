#!/usr/bin/env bash

# Copyright 2017 KubeSphere Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This script builds and link stamps the output

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
source "${KUBE_ROOT}/hack/lib/init.sh"

VERBOSE=${VERBOSE:-"0"}
V=""
if [[ "${VERBOSE}" == "1" ]];then
    V="-x"
    set -x
fi

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

OUTPUT_DIR=bin
BUILDPATH=./${1:?"path to build"}
OUT=${OUTPUT_DIR}/${1:?"output path"}

BUILD_GOOS=${GOOS:-linux}
BUILD_GOARCH=${GOARCH:-amd64}
GOBINARY=${GOBINARY:-go}
LDFLAGS=$(kube::version::ldflags)

BUILD_PLATFORMS=${DOCKER_PLATFORMS:-linux/amd64,linux/arm/v7,linux/arm64}
for BUILD_PLATFORM in $(echo ${BUILD_PLATFORMS}| tr "," "\n")
do
    echo "build image for $BUILD_PLATFORM"
    BUILD_VARS=(${BUILD_PLATFORM//// })
    BUILD_GOOS=${BUILD_VARS[0]}
    BUILD_GOARCH=${BUILD_VARS[1]}
    if [[ -v BUILD_VARS[2] ]]; then
        BUILD_VARIANT=${BUILD_VARS[2]}
    else
        BUILD_VARIANT=""
    fi
    # forgoing -i (incremental build) because it will be deprecated by tool chain.
    time GOOS=${BUILD_GOOS} CGO_ENABLED=0 GOARCH=${BUILD_GOARCH} ${GOBINARY} build \
            -ldflags="${LDFLAGS}" \
            -o ${OUTPUT_DIR}/${1:?"output path"}-${BUILD_GOOS}-${BUILD_GOARCH}${BUILD_VARIANT} \
            ${BUILDPATH}
done
