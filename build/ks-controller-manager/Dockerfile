# Copyright 2020 The KubeSphere Authors. All rights reserved.
# Use of this source code is governed by an Apache license
# that can be found in the LICENSE file.
FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.12

RUN apk add --no-cache ca-certificates

COPY  /bin/cmd/controller-manager-${TARGETOS:-linux}-${TARGETARCH:-amd64}${TARGETVARIANT} /usr/local/bin/controller-manager

EXPOSE 8443 8080

CMD ["sh"]