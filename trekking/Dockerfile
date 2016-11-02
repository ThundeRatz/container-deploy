FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
MAINTAINER Tiago Koji Castro Shibata


# General setup
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
RUN apt-get update && apt-get install --no-install-recommends -y build-essential sudo \
    && rm -rf /var/lib/apt/lists/*
RUN useradd -mG sudo ros && mkdir -p /etc/sudoers.d \
    && echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo_nopasswd


# ROS
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116 \
    && echo 'deb http://packages.ros.org/ros/ubuntu xenial main' > /etc/apt/sources.list.d/ros-latest.list
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install --no-install-recommends -y cmake ros-kinetic-desktop-full python-wstool \
    && rm -rf /var/lib/apt/lists/*


# Caffe deps
RUN apt-get update && apt-get install --no-install-recommends -y git gfortran \
    libatlas-base-dev libboost-all-dev libgflags-dev libgoogle-glog-dev libhdf5-serial-dev \
    libleveldb-dev liblmdb-dev libopencv-dev libprotobuf-dev libsnappy-dev protobuf-compiler \
    python-all-dev python-dev python-h5py python-matplotlib python-numpy python-opencv \
    python-pil python-pip python-protobuf python-scipy python-skimage python-sklearn \
    && rm -rf /var/lib/apt/lists/*
RUN git clone --depth=5 https://github.com/NVIDIA/caffe.git ~/caffe
RUN pip install -U pip && pip install -r ~/caffe/python/requirements.txt && rm -rf ~/.cache/pip
RUN mkdir -p ~/caffe/build && cd ~/caffe/build && cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. \
    && make -j4 all && make install && ln -s libcaffe-nv.so /usr/local/lib/libcaffe.so && rm -rf ~/caffe


# RTIMULib2
RUN git clone --depth=5 https://github.com/richardstechnotes/RTIMULib2.git ~/RTIMULib2
RUN mkdir ~/RTIMULib2/Linux/build && cd ~/RTIMULib2/Linux/build && cmake -DBUILD_GL=OFF .. \
    && make -j4 && sudo make install && rm -rf ~/RTIMULib2


# GPSd
RUN apt-get update && apt-get install --no-install-recommends -y ncurses-dev scons
RUN curl 'http://git.savannah.gnu.org/cgit/gpsd.git/snapshot/release-3.16.tar.gz' -O ~/release-3.16.tar.gz
RUN cd && tar xf release-3.16.tar.gz && cd release-3.16 && scons && scons udev-install

COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
