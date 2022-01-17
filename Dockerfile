FROM nvcr.io/nvidia/l4t-ml:r32.5.0-py3

# setup environment
ENV DEBIAN_FRONTEND noninteractive
ENV QEMU_EXECVE 1

USER root

## Preparation (based on JetPack44 Nvidea Image)
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip
RUN apt-get install -y python3-dev python3-pip libxslt-dev libxml2-dev libffi-dev \
                    libcurl4-openssl-dev libssl-dev libpng-dev libfreetype6-dev \
                    openmpi-doc openmpi-bin libopenmpi-dev libopenblas-dev git nano \
                    autoconf autotools-dev build-essential gcc git nano  \
                    python-dev libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev \
                    libsdl-ttf2.0-dev libhdf5-dev libsdl1.2-dev libsmpeg-dev  \
                    libportmidi-dev ffmpeg libswscale-dev libavformat-dev libavcodec-dev libfreetype6-dev
RUN apt-get install -y sudo vim nano htop unzip pkg-config \
                    libilmbase-dev libopenexr-dev libgstreamer1.0-dev \
                    libwebp-dev libatlas-base-dev libavformat-dev libswscale-dev libqtgui4 libqt4-test \
                    libjpeg-dev libpng-dev libtiff-dev  libv4l-dev libxvidcore-dev libx264-dev libgtk-3-dev

RUN pip3 install --upgrade pip && pip3 install scikit-build Shapely==1.5.9 scikit-image==0.16.2 torchvision imgaug

## Install donkey car
RUN git clone https://github.com/autorope/donkeycar /opt/donkeycar
RUN cd /opt/donkeycar \
        && git checkout master \
        && pip3 install -e .[nano]

RUN echo "export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1" >> ~/.bashrc

ARG OPENCV=4.1.0
RUN wget https://github.com/opencv/opencv/archive/${OPENCV}.tar.gz -O /tmp/opencv-${OPENCV}.tar.gz > /dev/null 2>&1 \
    && wget https://github.com/opencv/opencv_contrib/archive/${OPENCV}.tar.gz -O /tmp/opencv_contrib-${OPENCV}.tar.gz > /dev/null 2>&1 \
    && cd /tmp \
    && tar zxvf opencv-${OPENCV}.tar.gz \
    && tar zxvf opencv_contrib-${OPENCV}.tar.gz \
    && cd opencv-${OPENCV}/ \
    && mkdir build \
    && cd build/ \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_CUDA=ON -D CUDA_ARCH_BIN="5.3" -D CUDA_ARCH_PTX="" -D WITH_CUBLAS=ON -D ENABLE_FAST_MATH=ON -D CUDA_FAST_MATH=ON -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib-${OPENCV}/modules -D WITH_GSTREAMER=ON -D ENABLE_NEON=ON -D OPENCV_ENABLE_NONFREE=ON -D WITH_LIBV4L=ON -D BUILD_opencv_python2=OFF -D BUILD_opencv_python3=ON -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF .. \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/opencv*
 
RUN apt autoremove
COPY entrypoint.sh /

# setup docker user
ARG home=/home/jetson
WORKDIR ${home}
ENV DISPLAY :0
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]
