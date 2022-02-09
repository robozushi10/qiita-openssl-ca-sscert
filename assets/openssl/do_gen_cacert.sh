#!/bin/sh

mkdir -p /var/ssl/ca/private
mkdir -p /var/ssl/ca/certs

openssl req                            \
    -newkey rsa:4096                   \
    -nodes                             \
    -sha256                            \
    -x509                              \
    -days 36500                        \
    -keyout /var/ssl/ca/private/ca.key \
    -subj '/C=JP/ST=Tokyo/L=Shinjuku/O=Office/OU=Sales/CN=my_server/' \
    -out /var/ssl/ca/certs/ca.crt

