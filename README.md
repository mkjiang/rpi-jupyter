# rpi-jupyter
Jupyter Notebook Server on Raspberry Pi

To have your own Jupyter Notebook Server running 24/7 on Raspberry Pi. If connected to your router, with port forwarding and DDNS set up, you can carry out your Data Science tasks on the move.

Despite the fact that we adore Raspberry Pi and it is becoming more and more powerful, it is not intended to run large cpu intensive tasks. It will be slow and the best model only offers 1G of RAM. For larger datasets, you either need to use incremental machine learning algorithms or build a cluster and run Spark on it. I am currently working on the latter which would be interesting.

----------
This is a dockfile for building rpi-jupyter. The image is built on a Raspberry Pi 3 running [Hypriot OS](http://blog.hypriot.com/). It is a minimal notebook server with [resin/rpi-raspbian:jessie](https://hub.docker.com/r/resin/rpi-raspbian/) as base image without additional packages.  

Due to a popular python library called scikit-learn requires bzip2 library which needs to be installed before Python is compiled, I updated the image to 1.1.

I have also built maxjiang/rpi-jupyter:datascience (based on 1.1) so that you have most of the data science packages installed without installing/compiling them yourself.

### Installing
Go to [Hypriot OS](http://blog.hypriot.com/) and follow the steps to get the Raspberry Pi docker ready. Then, run the following:

Tags | Description
--- | ---
datascience | numpy scipy scikit-learn pandas seaborn matplotlib
1.1/latest | Python 3.6, Tini 0.14.0, jessie-20170315
1.0 | Python 3.5.1, Tini 0.9.0, jessie-20160525

    docker pull maxjiang/rpi-jupyter<:tag>


### Running in detached mode
    docker run -dp 8888:8888 maxjiang/rpi-jupyter 

Now you can access your notebook at `http://<docker host IP address>:8888`

### Configuration
If you would like to change some config, create your own jupyter_notebook_config.py on the docker host and run the following:

    docker run -itp <host port>:<dest port> -v <path to your config file>:/root/.jupyter/jupyter_notebook_config.py maxjiang/rpi-jupyter

This maps a local config file to the container.

The following command gives you a bash session in the running container so you could do more:

    docker exec -it <container id> /bin/bash

### For Data Scientists
Use the above command to open a new bash session in your container and run the following:

    sh datascience.sh
    
This will install almost all the Python modules you need for most Data Science tasks.
