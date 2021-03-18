From aitecmz/donkeycarbaseimage-v01 

# Copy the DonkeyCar configuration directory mycar to /var/local/donkey
RUN mkdir /usr/src/mycar
COPY ./mycar/ /usr/src/mycar
RUN chmod -R 600 /usr/src/mycar
RUN ls -la /usr/src/mycar

# Install DonkeyCar software
#RUN mkdir /var/local/projects
COPY ./donkeycar /var/local/projects/donkeycar
RUN cd /var/local/projects/donkeycar && \
       git checkout master \
       && pip install -e .[nano]

RUN export DISPLAY=:0

# This will install tensorflow as a system package
#RUN pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow==2.2.0+nv20.6

#ENV OPENCV_RELEASE_TAG 4.1.1
#RUN git clone --depth 1 -b ${OPENCV_RELEASE_TAG}  https://github.com/opencv/opencv.git /var/local/git/opencv
#RUN cd /var/local/git/opencv
#RUN mkdir -p /var/local/git/opencv/build && \
#    cd /var/local/git/opencv/build $$ && \
#    cmake -D CMAKE_INSTALL_PREFIX=/usr/local CMAKE_BUILD_TYPE=Release -D WITH_GSTREAMER=ON -D WITH_GSTREAMER_0_10=OFF -D WITH_CUDA=OFF -D WITH_TBB=ON -D WITH_LIBV4L=ON WITH_FFMPEG=ON -DOPENCV_GENERATE_PKGCONFIG=ON ..
#RUN  cd /var/local/git/opencv/build && \
#      make install
#USER root
#RUN export DISPLAY=:0
#USER $USER

WORKDIR /var/local/projects/donkycar

CMD ["python3", "/usr/src/mycar/manage.py", "drive"]
