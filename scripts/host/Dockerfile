FROM ubuntu:focal as builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y eatmydata \
    && eatmydata apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        autopoint \
        autotools-dev \
        bc \
        bison \
        build-essential \
        ca-certificates \
        ccache \
        cpio \
        curl \
        fakeroot \
        dwz \
        file \
        flex \
        gawk \
        gettext \
        git \
        gperf \
        gnupg \
        jimsh \
        libelf-dev \
        libexpat-dev \
        libftdi-dev \
        libgmp-dev \
        libhidapi-dev \
        libjaylink-dev \
        libjim-dev \
        liblzma-dev \
        libmpc-dev \
        libmpfr-dev \
        libncurses-dev \
        libssl-dev \
        libtool \
        libusb-1.0-0-dev \
        openssl \
        patchutils \
        pkg-config \
        python3 \
        rsync \
        tclsh \
        texinfo \
        unzip \
        wget \
        xxd \
        zip \
        zlib1g-dev




FROM builder as build_toolchain
WORKDIR /builder
ADD host/ /builder/

CMD /bin/bash
