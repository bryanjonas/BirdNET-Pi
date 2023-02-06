#!/usr/bin/env bash
# Install BirdNET script
set -x # Debugging
exec > >(tee -i installation-$(date +%F).txt) 2>&1 # Make log
set -e # exit installation if anything fails

my_dir=$HOME/BirdNET-Pi
export my_dir=$my_dir

cd $my_dir/scripts || exit 1

sudo -E HOME=$HOME USER=$USER /bin/bash install_services_docker.sh || exit 1
source $HOME/BirdNET-Pi/config/birdnet.conf

install_birdnet() {
  cd ~/BirdNET-Pi || exit 1
  echo "Establishing a python virtual environment"
  
  ##UNCOMMENT AFTER FINALIZING BUILD!!!
  ##python3 -m venv birdnet
  ###

  source ./birdnet/bin/activate
  pip3 install --default-timeout=900 -U -r $HOME/BirdNET-Pi/requirements.txt
}

[ -d ${RECS_DIR} ] || mkdir -p ${RECS_DIR} &> /dev/null

install_birdnet

cd $my_dir/scripts || exit 1

/bin/bash install_language_label.sh -l $DATABASE_LANG || exit 1

exit 0
