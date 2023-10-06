#!/bin/bash
set -e

sudo apt-get update && \
sudo apt-get install -y \
curl \
libcurl4-openssl-dev \
libelf-dev \
libdw-dev \
cmake \
gcc \
binutils-dev \
libiberty-dev \
build-essential \
zlib1g-dev \
git \
elfutils
echo "Dependencies installed"

wget https://github.com/SimonKagstrom/kcov/archive/master.tar.gz &&
tar xzf master.tar.gz &&
cd kcov-master &&
mkdir build &&
cd build &&
cmake .. &&
make &&
make install DESTDIR=../../kcov-build &&
cd ../.. &&
ls &&
rm -rf kcov-master &&
DIR=`find target/debug/deps/* -iname "pravega*[^\.d]"` |
for file in $DIR; do [ -x "${file}" ] || continue; mkdir -p "target/cov/$(basename $file)"; ./kcov-build/usr/local/bin/kcov --exclude-pattern=/.cargo,/usr/lib --verify "target/cov/$(basename $file)" "$file"; done &&
bash <(curl -s https://codecov.io/bash) -t 810699b6-005c-40f3-bae6-3337a7da4e75 &&
echo "Uploaded code coverage"