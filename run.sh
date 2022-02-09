#!/bin/bash
 
test -z "$1" && echo 'ERROR: $1 is empty. $1 set to IP'       && exit 2
test -z "$2" && echo 'ERROR: $2 is empty. $2 set to HOSTNAME' && exit 2

#----------------------------------------------------------------
# Clean up
#----------------------------------------------------------------
docker-compose stop openssl
docker-compose down --rmi all  --volumes --remove-orphans

#----------------------------------------------------------------
# Preparation
#----------------------------------------------------------------
sudo rm -rf ./PV
test ! -d ./PV.tmpl && echo 'Error: could not found ./PV.tmpl' && exit 4
cp -rp PV.tmpl PV

sed -e "s/{{MY_MACHINE_IP}}/$1/g" -e "s/{{MY_MACHINE_NAME}}/$2/g" PV/etc/ssl/openssl.cnf.tmpl | tee PV/etc/ssl/openssl.cnf
sed -e "s/{{MY_MACHINE_IP}}/$1/g" -e "s/{{MY_MACHINE_NAME}}/$2/g" assets/openssl/do_gen_cacert.sh.tmpl  | tee assets/openssl/do_gen_cacert.sh
chmod +x assets/openssl/do_gen_cacert.sh

#----------------------------------------------------------------
# Build
#----------------------------------------------------------------
set -x
docker-compose build
docker-compose up -d
docker-compose exec openssl sh -c 'cd /root/; sh do_gen_cacert.sh'
set +x


