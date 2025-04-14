#!/bin/sh
docker run --privileged -it --rm -v `pwd`/toolchain:/output builder sh -e -c "LIBC_SHORT=musl ./make_toolchain.sh"
