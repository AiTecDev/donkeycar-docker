FROM nvcr.io/nvidia/l4t-ml:r32.5.0-py3
# setup environment
ENV DEBIAN_FRONTEND noninteractive
ENV QEMU_EXECVE 1

USER root

## Preparation (based on JetPack44 Nvidea Image)
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y sudo wget locate vim nano htop
## Install donkey car
RUN git clone https://github.com/autorope/donkeycar /opt/donkeycar
RUN cd /opt/donkeycar \
        && git checkout master \
        && pip3 install -e .[nano] 
RUN pip3 install --upgrade pip setuptools wheel &&  pip3 install Shapely==1.5.9 scikit-image==0.16.2  \
    && pip3 install --no-deps imgaug \ 
    && echo "export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1" >> ~/.bashrc

COPY entrypoint.sh /

# setup docker user
ARG home=/home/jetson
WORKDIR ${home}
ENV DISPLAY :0
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]
