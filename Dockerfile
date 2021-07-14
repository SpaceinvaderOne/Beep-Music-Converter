FROM ganesh2docker/phython2:latest
MAINTAINER SpaceinvaderOne
RUN apt-get update && apt-get -y install beep bash sox rsync libsox-fmt-mp3 python-pip && python -m pip install numpy scipy
COPY . /beep
VOLUME /config
CMD chmod 777 /beep/unraid.sh && bash /beep/unraid.sh ; sleep 240
