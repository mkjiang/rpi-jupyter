# This file creates a container that runs a jupyter notebook server on Raspberry Pi
#
# Author: Max Jiang
# Date 13/02/2017

FROM resin/rpi-raspbian:jessie
MAINTAINER Max Jiang <maxjiang@hotmail.com>

USER root

# Set the variables
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHON_VERSION 3.6.0
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER 

# Install packages necessary for compiling python
RUN apt-get update && apt-get upgrade && apt-get install -y \
        build-essential \
        libncursesw5-dev \
        libgdbm-dev \
        libc6-dev \
        zlib1g-dev \
        libsqlite3-dev \
        tk-dev \
        libssl-dev \
        openssl \
        libbz2-dev \
        vim

# Download and compile python
RUN apt-get install -y ca-certificates
ADD "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" Python-${PYTHON_VERSION}.tgz
RUN tar zxvf "Python-${PYTHON_VERSION}.tgz" \
        && cd Python-${PYTHON_VERSION} \
        && ./configure \
        && make \
        && make install \
        && cd .. \
        && rm -rf "./Python-${PYTHON_VERSION}" \
        && rm "./Python-${PYTHON_VERSION}.tgz"

# Update pip and install jupyter
RUN apt-get install -y libncurses5-dev
RUN pip3 install --upgrade pip
RUN pip3 install readline jupyter

USER $NB_USER
# Setup jovyan home directory
RUN mkdir /home/$NB_USER/work && \
    mkdir /home/$NB_USER/.jupyter && \
    echo "cacert=/etc/ssl/certs/ca-certificates.crt" > /home/$NB_USER/.curlrc

# Configure jupyter
RUN jupyter notebook --generate-config
RUN sed -i "/c.NotebookApp.open_browser/c c.NotebookApp.open_browser = False" /home/$NB_USER/.jupyter/jupyter_notebook_config.py \      
        && sed -i "/c.NotebookApp.ip/c c.NotebookApp.ip = '*'" /home/$NB_USER/.jupyter/jupyter_notebook_config.py \        
        && sed -i "/c.NotebookApp.notebook_dir/c c.NotebookApp.notebook_dir = '/home/$NB_USER/work'" /home/$NB_USER/.jupyter/jupyter_notebook_config.py
VOLUME /home/$NB_USER/work

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
USER root
ENV TINI_VERSION 0.14.0
ENV CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"

ADD https://github.com/krallin/tini/archive/v${TINI_VERSION}.tar.gz v${TINI_VERSION}.tar.gz
RUN apt-get install -y cmake
RUN tar zxvf v${TINI_VERSION}.tar.gz \
        && cd tini-${TINI_VERSION} \
        && cmake . \
        && make \
        && cp tini /usr/bin/. \
        && cd .. \
        && rm -rf "./tini-${TINI_VERSION}" \
        && rm "./v${TINI_VERSION}.tar.gz"

ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
WORKDIR /home/$NB_USER/work

CMD ["jupyter", "notebook"]
RUN chown -R $NB_USER:users /home/$NB_USER

USER $NB_USER
COPY datascience.sh /home/$NB_USER/

