# use the latest mysql version
FROM larsklitzke/alpine-llvm7.0:latest
MAINTAINER Lars Klitzke <Lars.Klitzke@gmail.com>

# VERSIONS
ENV PYTHON_VERSION=3.5.6

RUN apk --no-cache add tar wget

# Add the python sources
RUN wget https://github.com/python/cpython/archive/v3.5.6.tar.gz && tar xvf v3.5.6.tar.gz

# replace librressl with openssl
RUN apk --no-cache del libressl-dev

# install build dependencies
RUN apk update && \
    apk --no-cache add \
        build-base \
        linux-headers \
        git \
        openssl-dev \
        make \
        openjpeg-dev \
        tiff-dev \
        zlib-dev \
        libxslt-dev \
        sqlite \
        sqlite-dev \
        bzip2-dev \
        readline-dev \
        xz-dev


RUN cd /cpython-3.5.6 && \
    ./configure --enable-optimizations --enable-loadable-sqlite-extensions --enable-shared && \
    make -j$(nproc)

RUN cd /cpython-3.5.6 && make install

# Set symlinks
RUN rm /usr/bin/python /usr/bin/pip; \
    ln -s /usr/local/bin/python3 /usr/bin/python; \
    ln -s /usr/local/bin/pip3 /usr/bin/pip;

# cleanup
RUN rm -r /cpython-3.5.6

