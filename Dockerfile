FROM nvcr.io/nvidia/l4t-ml:r32.5.0-py3
# setup environment
ENV DEBIAN_FRONTEND noninteractive
ENV QEMU_EXECVE 1

USER root

## Preparation (based on JetPack45 Nvidea Image)
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y sudo wget locate vim nano htop nmap ffmpeg
## Install donkey car
RUN git clone https://github.com/autorope/donkeycar /opt/donkeycar
RUN cd /opt/donkeycar \
        && git checkout master \
        && pip3 install -e .[nano] 
RUN pip3 install --upgrade pip setuptools wheel &&  pip3 install Shapely==1.5.9 scikit-image==0.16.2 imageio PyWavelets \
    && pip3 install --no-deps imgaug kivy plotly moviepy \ 
    && pip3 install git+https://github.com/autorope/keras-vis.git \
    && echo "export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1" >> ~/.bashrc

RUN pip3 install https://developer.download.nvidia.com/compute/redist/jp/v45/tensorflow/tensorflow-2.3.1+nv20.12-cp36-cp36m-linux_aarch64.whl
# sudo -H pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow==2.2.0+nv20.6
RUN apt-get install -y libopenblas-base libopenmpi-dev && \
    wget https://nvidia.box.com/shared/static/wa34qwrwtk9njtyarwt5nvo6imenfy26.whl -O torch-1.7.0-cp36-cp36m-linux_aarch64.whl &&  \
    pip3 install ./torch-1.7.0-cp36-cp36m-linux_aarch64.whl && \
    apt-get install -y libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libswscale-dev


COPY entrypoint.sh /

# setup docker user
ARG home=/home/jetson
WORKDIR ${home}
ENV DISPLAY :0
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]
