FROM aitecmz/donkeycarbase

# Install DonkeyCar software
#RUN mkdir /var/local/projects
RUN git clone https://github.com/autorope/donkeycar && cd donkeycar && git checkout dev && pip install -e .[nano]
RUN donkey createcar --path /var/local/projects/donkeycar
RUN git clone https://github.com/AiTecDev/donkeycar-docker.git && cd donkeycar-docker/mycar && cp myconfig.py /var/local/projects/donkeycar

ENV DISPLAY :0
WORKDIR /var/local/projects/donkeycar

CMD ["python3", "/var/local/projects/donkeycar/manage.py", "drive"]
##CMD ["donkey", "train"]
