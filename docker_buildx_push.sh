#!/usr/bin/env bash

set -ex
set -o pipefail

IMAGE_REPO="lisy09kubesphere"
IMAGE_VERSION="v3.0.0"
DOCKER_PLATFORMS="linux/amd64,linux/arm/v7,linux/arm64"

echo 'Build and push ks-apiserver'
docker buildx build \
--push \
--file build/ks-apiserver/Dockerfile \
--tag $IMAGE_REPO/ks-apiserver:$IMAGE_VERSION \
--platform $DOCKER_PLATFORMS .

echo 'Build and push ks-controller-manager'
docker buildx build \
--push \
--file build/ks-controller-manager/Dockerfile \
--tag $IMAGE_REPO/ks-controller-manager:$IMAGE_VERSION \
--platform $DOCKER_PLATFORMS .