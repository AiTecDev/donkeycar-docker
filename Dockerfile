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

WORKDIR /var/local/projects/donkycar

CMD ["python3", "/usr/src/mycar/manage.py", "drive"]
