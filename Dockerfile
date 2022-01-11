FROM aitecmz/donkeycarbase

USER root

## donkey car
RUN pip3 install Adafruit_PCA9685

RUN git clone https://github.com/autorope/donkeycar /opt/donkeycar
RUN cd /opt/donkeycar \
        && git checkout master \
        && pip3 install -e .[nano]
