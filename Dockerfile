# use the latest mysql version
FROM larsklitzke/alpine-llvm7.0:latest
MAINTAINER Lars Klitzke <Lars.Klitzke@gmail.com>

# VERSIONS
ENV PYTHON_VERSION=3.5.7

RUN apk --no-cache add tar wget

# Add the python sources
RUN wget https://github.com/python/cpython/archive/v3.5.7rc1.tar.gz && tar xvf v3.5.7rc1.tar.gz

# replace librressl with openssl
RUN apk --no-cache del libressl-dev

# install build dependencies
RUN apk update && \
    apk --no-cache add \
        build-base \
        linux-headers \
        gcc \
        wget \
        git \
        g++ \
        openssl-dev \
        make \
        openjpeg-dev \
        tiff-dev \
        zlib-dev \
        libxml2-dev \
        libxslt-dev \
        sqlite \
        sqlite-dev \
        bzip2-dev \
        python3-tkinter \
        ncurses-dev \
        readline-dev \
        xz-dev


RUN cd /cpython-3.5.7rc1 && \
    ./configure --enable-optimizations --enable-loadable-sqlite-extensions && \
    make -j$(nproc) && make -j$(nproc) test

RUN cd /cpython-3.5.7rc1 && make install

# cleanup
RUN rm -r /cpython-3.5.7rc1