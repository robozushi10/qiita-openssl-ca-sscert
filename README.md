## 使い方

### 形式

```bash
$ bash run.sh <IP> <マシン名>
```

　

### 実行例

```bash
$ bash run.sh 192.168.1.10 my_server
```

　

### 結果


次のように CA のサーバ証明書が作成される.

```bash
PV/var/ssl/ca/certs/ca.cert
```

　

## 仕様

### ファイル構成

```bash

$ tree . --charset=C  -I '__pycache__|*.ORIG|セットアップ*' --dirsfirst 
.
|-- PV.tmpl
|   |-- etc
|   |   `-- ssl ........................................ DockerHub の alpine/openssl 内に存在する /etc/ssl 以下をコピーしたもの
|   |       |-- certs
|   |       |   `-- ca-certificates.crt
|   |       |-- misc
|   |       |   |-- CA.pl
|   |       |   |-- tsget -> tsget.pl
|   |       |   `-- tsget.pl
|   |       |-- private
|   |       |-- cert.pem -> certs/ca-certificates.crt
|   |       |-- ct_log_list.cnf
|   |       |-- ct_log_list.cnf.dist
|   |       |-- openssl.cnf.dist
|   |       |-- openssl.cnf.ORIG ... DockerHub の alpine/openssl 内に存在していたオリジナル openssl.cnf である
|   |       `-- openssl.cnf.tmpl ... 時前で用意したファイル. 「run.sh の引数で書き換えるための目印あり」
|   `-- var ........................ 各種データの生成先
|       `-- ssl
|           `-- ca
|               |-- certs .......... CA証明書 (=サーバ証明書) の出力先である
|               |-- private ........ CA秘密鍵 (=サーバ秘密鍵) の出力先である
|               |-- index.txt
|               `-- serial ......... 値「01」である
|-- assets
|   `-- openssl
|       |-- Dockerfile ............. run.sh により生成された do_gen_cacert.sh をコンテナ内の /root/. に配置するだけ.
|       `-- do_gen_cacert.sh.tmpl .. openssl req 〜 コマンドの雛形.
|                                    run.sh を実行することで必要なパラメータが埋められて do_gen_cacert.sh が生成される.
`-- run.sh ......................... assets/openssl/do_gen_cacert.sh.tmpl にパラメータを代入して do_gen_cacert.sh を生成する.
                                     PV.tmpl/etc/ssl/openssl.cnf.tmpl にパラメータを代入して PV/etc/ssl/openssl.cnf を生成する.
```

　

## その他

### 証明書が正しく生成されたか否かを確認したい

```bash
$ openssl x509 -in PV/var/ssl/ca/certs/ca.cert -text
```

