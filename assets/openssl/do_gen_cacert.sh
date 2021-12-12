#!/bin/sh
#
# note:
#     本バッチで作成する ca.crt は Docker コンテナ内で使う想定のため、IPアドレスでの指定は想定していない.
#     もしも IP アドレスで指定したい場合は、「./PV/etc/ssl/openssl.cnf」での「 [v3_ca] 」を次のように変えること.
#
#     subjectAltName = DNS:my_private_registry
#     ↓
#     subjectAltName = IP:192.168.1.100
#
# ref:
#     https://qiita.com/reoring/items/0da3aa9935c68aa95e88
#     https://qiita.com/3244/items/780469306a3c3051c9fe
#     「目で見て体験! Kubernetes のしくみ Lチカでわかるオーケストレーション」(P38)
#

openssl req                            \
    -newkey rsa:4096                   \
    -nodes                             \
    -sha256                            \
    -x509                              \
    -days 36500                        \
    -keyout /var/ssl/ca/private/ca.key \
    -subj '/C=JP/ST=Tokyo/L=Chiyoda/O=ORGANIZATION/OU=ORGANIZATION_UNIT/CN=mymy/' \
    -out /var/ssl/ca/certs/ca.crt

