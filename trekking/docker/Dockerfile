FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
MAINTAINER Tiago Koji Castro Shibata


# General setup
RUN apt-get update && apt-get install --no-install-recommends -y build-essential locales sudo \
    && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
# Configure PATH for all users
RUN echo PATH="/usr/local/nvidia/bin:/usr/local/cuda/bin:$PATH" > /etc/profile.d/nvidia-path.sh


# ROS
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116 \
    && echo 'deb http://packages.ros.org/ros/ubuntu xenial main' > /etc/apt/sources.list.d/ros-latest.list
ENV ROS_DISTRO kinetic
RUN apt-get update \
    && apt-get install --no-install-recommends -y cmake ros-kinetic-desktop-full ros-kinetic-robot-localization python-wstool \
    && rm -rf /var/lib/apt/lists/*
RUN useradd -mG sudo ros && echo source "/opt/ros/$ROS_DISTRO/setup.bash" >> ~ros/.bashrc \
    && mkdir -p /etc/sudoers.d && echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo_nopasswd


# RTIMULib2
RUN git clone --depth=5 https://github.com/richardstechnotes/RTIMULib2.git ~/RTIMULib2
RUN mkdir ~/RTIMULib2/Linux/build && cd ~/RTIMULib2/Linux/build && cmake -DBUILD_GL=OFF .. \
    && make -j4 && sudo make install && rm -rf ~/RTIMULib2


# Other packages: gpsd, v4l-utils (for v4l2-ctl)
RUN apt-get update \
    && apt-get install --no-install-recommends -y gpsd libgps-dev libv4l-dev \
    && rm -rf /var/lib/apt/lists/*


COPY ./run.sh /home/ros/
COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["/home/ros/run.sh"]
