# This Dockerfile builds btcd from source and creates a small (55 MB) docker container based on alpine linux.
#
# Clone this repository and run the following command to build and tag a fresh btcd amd64 container:
#
# docker build . -t yourregistry/btcd
#
# You can use the following command to buid an arm64v8 container:
#
# docker build . -t yourregistry/btcd --build-arg ARCH=arm64v8
#
# For more information how to use this docker image visit:
# https://github.com/btcsuite/btcd/tree/master/docs
#
# 8333  Mainnet Bitcoin peer-to-peer port
# 8334  Mainet RPC port
ARG ARCH=amd64

FROM golang:1.14-alpine3.12 AS build-container
USER root

ARG ARCH
ENV GO111MODULE=on

COPY . /root
WORKDIR /root
RUN set -ex \
  && if [ "${ARCH}" = "amd64" ]; then export GOARCH=amd64; fi \
  && if [ "${ARCH}" = "arm32v7" ]; then export GOARCH=arm; fi \
  && if [ "${ARCH}" = "arm64v8" ]; then export GOARCH=arm64; fi \
  && echo "Compiling for $GOARCH" \
  && go install -v . ./cmd/...

#FROM $ARCH/alpine:3.12

#COPY --from=build-container /go/bin /bin
ARG BTCD_DATADIR=${BTCD_DATADIR}
VOLUME $BTCD_DATADIR
#EXPOSE 8332 8333 28332 28333 28334 38332 38333 38334
EXPOSE 38334

#RUN mkdir -p /root/.btcd
#ADD btcd.conf /root/.btcd

EXPOSE 38334

ENTRYPOINT ["btcd"]
