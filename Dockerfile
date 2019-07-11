FROM python:3.5-alpine3.9
MAINTAINER Lars Klitzke <Lars.Klitzke@gmail.com>

# install llvm in version 7.0.x
RUN wget http://releases.llvm.org/7.0.1/llvm-7.0.1.src.tar.xz && tar xvf llvm-7.0.1.src.tar.xz

# add llvm dependencies
RUN apk --no-cache add \
	autoconf \
	automake \
	freetype-dev \
	g++ \
	gcc \
	cmake \
	make \
    libxml2-dev \
    python2 \
    ncurses-dev

# configure LLVM using CMake
RUN cd llvm-7.0.1.src && mkdir build && cd build && cmake .. \
    -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="X86" \
    -DCMAKE_BUILD_TYPE=MinSizeRel

# build and install LLVM
RUN cd llvm-7.0.1.src/build && make -j$(nproc) && make install

RUN cd llvm-7.0.1.src/build && make -j test
# cleanup
RUN rm -r llvm-7.0.1.src