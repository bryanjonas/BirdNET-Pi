FROM python:3.8-slim

RUN apt update -y && \
    apt install -y debian-keyring debian-archive-keyring apt-transport-https apt-utils curl && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list

RUN apt -qqq update && apt -qqy upgrade

RUN echo "icecast2 icecast2/icecast-setup boolean false" | debconf-set-selections

RUN apt install -qqy caddy ftpd sqlite3 php-sqlite3 alsa-utils \
      pulseaudio avahi-utils sox libsox-fmt-mp3 php php-fpm php-curl php-xml \
      php-zip icecast2 swig ffmpeg wget unzip curl cmake make bc libjpeg-dev \
      zlib1g-dev python3-dev python3-pip python3-venv lsof git sudo jq cron \
      net-tools

RUN useradd -m -d /home/birdie birdie

RUN passwd -d birdie

RUN usermod -aG sudo birdie

USER birdie

ENV HOME /home/birdie

ENV USER birdie

WORKDIR $HOME

RUN git clone https://github.com/bryanjonas/BirdNET-Pi.git

WORKDIR $HOME/BirdNET-Pi/

RUN mkdir $HOME/BirdNET-Pi/config

COPY ./config/birdnet.conf $HOME/BirdNET-Pi/config

### Remove once updated on remote
COPY requirements.txt . 

##UNCOMMENT AFTER FINALIZING BUILD!!!
## Here to speed the build process
RUN python3 -m venv birdnet && \
    . birdnet/bin/activate && \
    pip3 install --default-timeout=900 -U -r $HOME/BirdNET-Pi/requirements.txt
###

COPY scripts/install_birdnet_docker.sh $HOME/BirdNET-Pi/scripts/
COPY scripts/install_services_docker.sh $HOME/BirdNET-Pi/scripts/
#COPY scripts/birdnet_analysis_docker.sh $HOME/BirdNET-Pi/scripts/
#COPY scripts/server_docker.py $HOME/BirdNET-Pi/scripts/
###


RUN /bin/bash $HOME/BirdNET-Pi/scripts/install_birdnet_docker.sh






