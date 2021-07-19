FROM aitecmz/donkeycarbaseimage-v01 

# Install DonkeyCar software
#RUN mkdir /var/local/projects
COPY ./donkeycar /var/local/projects/donkeycar
RUN cd /var/local/projects/donkeycar && \
       git checkout master \
       && pip install -e .[nano]

RUN export DISPLAY=:0

WORKDIR /var/local/projects/donkycar

#joystick need NOT to be sticky and in "myconfig.py" the variable USE_JOYSTICK_AS_DEFAULT set to False
#or it is commented out 
#CMD ["python3", "/home/zamy/mycar/manage.py", "drive", "--js"]

#joystick need to be sticky and in "myconfig.py" the variable USE_JOYSTICK_AS_DEFAULT set to True
CMD ["python3", "/home/zamy/mycar/manage.py", "drive"]
