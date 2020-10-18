FROM golang:1.13.6-alpine3.11 as buildergo

RUN apk update && apk add curl \
                          git \
                          make \
                          openssh-client && \
     rm -rf /var/cache/apk/*

FROM alpine:3.12

RUN apk add --no-cache ca-certificates 

# To speed up building process, we copy binary directly from make
# result instead of building it again, so make sure you run the 
# following command first before building docker image
#   make ks-apiserver
#
COPY /bin/cmd/ks-apiserver-${TARGETOS:-linux}-${TARGETARCH:-amd64}${TARGETVARIANT} /usr/local/bin/ks-apiserver

EXPOSE 9090
CMD ["sh"]
