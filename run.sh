#!/bin/bash
 
echo "[DEBUG]: ARGUMENTS => <$@>"
GETOPT=`getopt -q -o a -l ip:,dns: -- "$@"` ; [ $? != 0 ] && exit 49
eval set -- "$GETOPT"
echo "[DEBUG]: ARGUMENTS => <$@>"
 
FOUND=""
DNS=""
IP=""

while true
do
  echo "-----------------------------------"
  echo "\$1 => <$1>"
  echo "\$2 => <$2>"
  case $1 in
    --ip)
        test ! -z "$FOUND" && break
        IP=$2
        FOUND=1
        echo "IP::: $IP"
        shift 2 ;;
    --dns)
        test ! -z "$FOUND" && break
        DNS=$2
        FOUND=1
        shift 2 ;;
    --) shift ; break ;; #! オプション部終了
    *)  echo "INVALID ARGUMENT is <$1>"  ; exit 4 ;;
  esac
done
 

#----------------------------------------------------------------
# Clean up
#----------------------------------------------------------------
docker-compose stop openssl
docker-compose down --rmi all  --volumes --remove-orphans

#----------------------------------------------------------------
# Preparation
#----------------------------------------------------------------
rm -rf ./PV
test ! -d ./PV.tmpl && echo 'Error: could not found ./PV.tmpl' && exit 4
cp -rp PV.tmpl PV

test ! -z "$DNS" && {
  sed -e "s/{{MY_DEF_TYPE}}/DNS/g" -e "s/{{MY_MACHINE_NAME}}/$DNS/g" PV/etc/ssl/openssl.cnf.tmpl | tee PV/etc/ssl/openssl.cnf
  sed -e "s/{{MY_DEF_TYPE}}/DNS/g" -e "s/{{MY_MACHINE_NAME}}/$DNS/g" assets/openssl/do_gen_cacert.sh.tmpl  | tee assets/openssl/do_gen_cacert.sh
  chmod +x assets/openssl/do_gen_cacert.sh
} || {
  sed -e "s/{{MY_DEF_TYPE}}/IP/g" -e "s/{{MY_MACHINE_NAME}}/$IP/g" PV/etc/ssl/openssl.cnf.tmpl | tee PV/etc/ssl/openssl.cnf
  sed -e "s/{{MY_DEF_TYPE}}/IP/g" -e "s/{{MY_MACHINE_NAME}}/$IP/g" assets/openssl/do_gen_cacert.sh.tmpl  | tee assets/openssl/do_gen_cacert.sh
  chmod +x assets/openssl/do_gen_cacert.sh
}

#----------------------------------------------------------------
# Build
#----------------------------------------------------------------
set -x
docker-compose build
docker-compose up -d
docker-compose exec openssl sh -c 'cd /root/; sh do_gen_cacert.sh'
set +x


