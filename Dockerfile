FROM aitecmz/donkeycarbaseimage 

# Install DonkeyCar software
#RUN mkdir /var/local/projects
RUN git clone https://github.com/autorope/donkeycar && cd donkeycar && git checkout dev && pip install -e .[nano]
RUN donkey createcar --path /var/local/projects/donkycar
RUN git clone https://github.com/AiTecDev/donkeycar-docker.git && cd donkeycar-docker/mycar && cp myconfig.py /var/local/projects/donkycar

ENV DISPLAY :0

WORKDIR /var/local/projects/donkycar
CMD ["python3", "/var/local/projects/donkycar/manage.py", "drive"]

