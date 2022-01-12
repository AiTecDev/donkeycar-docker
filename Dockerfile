FROM arm64v8/ubuntu

# setup environment
ENV DEBIAN_FRONTEND noninteractive
ENV QEMU_EXECVE 1

USER root

## Preparation (based on JetPack44 Nvidea Image)
RUN apt-get update -y && apt-get upgrade -y 
RUN apt-get install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip \
                    libjpeg8-dev liblapack-dev libblas-dev gfortran
RUN apt-get install -y python3-dev python3-pip libxslt-dev libxml2-dev libffi-dev \
                    libcurl4-openssl-dev libssl-dev libpng-dev libfreetype6-dev \
                    openmpi-doc openmpi-bin libopenmpi-dev libopenblas-dev git nano \
                    autoconf autotools-dev build-essential gcc git nano python-h5py \
                    python-dev libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev \
                    libsdl-ttf2.0-dev libhdf5-dev libsdl1.2-dev libsmpeg-dev python-numpy subversion \
                    libportmidi-dev ffmpeg libswscale-dev libavformat-dev libavcodec-dev libfreetype6-dev

# Install python3.8
RUN apt-get install -y python3.8 \
            && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1 \
            && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2 \
            && sudo update-alternatives --config python3 < 0


# Install Python Packages
RUN pip3 install --upgrade setuptools wheel pip  testresources
RUN pip3 install --upgrade numpy
RUN pip3 install -U futures==3.1.1 protobuf==3.12.2 pybind11==2.5.0
RUN pip3 install -U cython==0.29.21 pyserial
RUN pip3 install -U future==0.18.2 mock==4.0.2 h5py=2.7.1 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.3.3
RUN pip3 install -U absl-py==0.9.0 py-cpuinfo==7.0.0 psutil==5.7.2 portpicker==1.3.1 six requests==2.24.0 astor==0.8.1 termcolor==1.1.0 wrapt==1.12.1 google-pasta==0.2.0
RUN pip3 install -U gdown


## Install Tensorflow
RUN pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow

## Install Torch Torchvivion, Opencv & imgaug
RUN apt-get install -y libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev wget
RUN pip3 install -U torch==1.7.0+cpu torchvision==0.8.1+cpu torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html

## Install donkey car
RUN git clone https://github.com/autorope/donkeycar /opt/donkeycar
RUN cd /opt/donkeycar \
        && git checkout master \
        && pip3 install -e .[nano] 

RUN echo "export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1" >> ~/.bashrc

COPY entrypoint.sh /

# setup docker user
ARG user=jetson
ARG home=/home/jetson
USER ${user}
WORKDIR ${home}

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]