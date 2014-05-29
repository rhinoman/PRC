#!/bin/bash -e
# Installs requirements for PDAL
source ./scripts/ci/common.sh
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 16126D3A3E5C1192
sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo apt-get install python-software-properties -y
sudo add-apt-repository ppa:ubuntugis/ppa -y
sudo add-apt-repository ppa:boost-latest/ppa -y
sudo apt-get update -qq
sudo apt-get install \
    cmake \
    automake \ 
    libflann-dev \
    libgdal-dev \
    libgeos-dev \
    libgeos++-dev \
    libpq-dev \
    libproj-dev \
    libtiff4-dev \
    libxml2-dev \
    python-numpy \
    boost1.55

# install libgeotiff from sources
wget http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.0.tar.gz
tar -xzf libgeotiff-1.4.0.tar.gz
cd libgeotiff-1.4.0
./configure --prefix=/usr && make && sudo make install
cd $TRAVIS_BUILD_DIR
# check out and build PDAL
git clone https://github.com/PDAL/PDAL.git 
cd PDAL
mkdir -p _pdal_build || exit 1
cd _pdal_build || exit 1
cmake -G "Unix Makefiles" \
  -DWITH_GDAL=ON \
  -DWITH_LIBXML2=ON \
  -DWITH_PGPOINTCLOUD=ON \
  -DPDAL_EMBED_BOOST=OFF \
  ..

make && sudo make install
cd $TRAVIVS_BUILD_DIR
#check out and build libharu
git clone https://github.com/libharu/libharu.git
cd libharu
mkdir -p _libharu_build || exit 1
cd _libharu_build || exit 1
./buildconf.sh && ./configure && make && sudo make install
cd $TRAVIS_BUILD_DIR

gcc --version
clang --version
