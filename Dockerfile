FROM nvcr.io/nvidia/l4t-ml:r32.4.4-py3

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

## Install donkey car
RUN git clone https://github.com/autorope/donkeycar /opt/donkeycar
RUN cd /opt/donkeycar \
        && git checkout master \
        && pip3 install -e .[nano]

RUN echo "export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1" >> ~/.bashrc
RUN apt-get install -y sudo vim nano htop
RUN pip3 install --upgrade pip && pip3 install scikit-build opencv-python
COPY entrypoint.sh /

# setup docker user
ARG home=/home/jetson
WORKDIR ${home}
ENV DISPLAY :0
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]
