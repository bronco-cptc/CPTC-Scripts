#!/bin/bash
apt-get install -y libssl-dev libffi-dev python-dev build-essential
pip install pipenv
git clone --recursive https://github.com/byt3bl33d3r/CrackMapExec
cd CrackMapExec && pipenv install
pipenv shell
python setup.py install
