#! /usr/bin/bash

kubectl create secret generic -n demo pg-custom-config --from-file=./user.conf
