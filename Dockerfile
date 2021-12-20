FROM aitecmz/donkeycarbaseimage

# Install DonkeyCar software
RUN git clone https://github.com/autorope/donkeycar && cd donkeycar && git checkout dev && pip install -e .[nano]
ENV DISPLAY :0
RUN donkey createcar --path /var/local/projects/donkycar
COPY defaultconfig.py /var/local/projects/donkycar/myconfig.py
WORKDIR /var/local/projects/donkycar

CMD ["python3", "/var/local/projects/donkycar/manage.py", "drive"]
