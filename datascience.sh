#!/bin/sh
# After running this script, you should be able to carry out most of your data science tasks. 
# I deliberately seperated this from the dockerfile to keep the docker image as clean as possible
# Some useful tools
apt-get update && apt-get install -y wget git

# Required for pandas hdf5, sci-pi
apt-get install -y libhdf5-dev liblapack-dev gfortran

# Python packages for data science
pip3 install numpy scipy pandas scikit-learn nltk seaborn tables matplotlib
