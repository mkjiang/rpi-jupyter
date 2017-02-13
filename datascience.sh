#!/bin/sh

# After running this script, you should be able to carry out most of your data science tasks. 
# I deliberately seperated this from the dockerfile to keep the docker image as clean as possible

# Some useful tools
apt-get update && apt-get install -y vim wget

# Required for sk-learn and pandas hdf5
apt-get install libbz2-dev libhdf5-dev 

# Python packages for data science
pip3 install numpy scipy panads scikit-learn sns tables matplotlib
