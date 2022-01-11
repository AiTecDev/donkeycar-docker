# donkeycar-docker
This Dockerfile uses the Nvidea L4T ML Image with opencv, tensorflow etc as base for a donkey car docker container.
The Container is managed by docker compose and to create a new car use the following syntax: 

sudo docker-compose run --rm jetson donkey createcar --path /var/local/projects/donkeycar/mycar

After having created a car you can use the donkey car confguration in the mycar folder as initial start.
To drive your new car use:

sudo docker-compose run --rm jetson donkey drive

You can collect data and let us start train the car with:

sudo docker-compose run --rm jetson donkey  train --tub ./data --model ./models/mypilot.h5


