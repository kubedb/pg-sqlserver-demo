#! /usr/bin/bash
kubectl create secret tls issuer-ca --cert=ca.crt  --key=ca.key --namespace=demo
