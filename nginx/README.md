<div align="center">
    <img src="../asset/nginx.png">
</div>

## Getting Started
Nginx ialah hal yang serupa dengan apache2. Nginx web server yang memiliki peforma jauh lebih kencang ketimbang apache2 dalam hal response. Nginx belakangan ini kerap kali ramai diperbincangkan. Bahkan selain menjadi web server, digunakan juga untuk load balancer, proxy pass, dsb. Lalu bagaimana kita mengamankan aplikasi sebagus ini ? Sebenarnya sama saja kaya apache2 namun ada sedikit perbedaan dalam hal installasi

## Server Tokens
Berbeda dengan apache2, nginx tidak menampilkan server signaturenya. Ia hanya menampilkan server tokensnya saja. Hal ini juga perlu di patching karena setiap versi nginx itu ada vulnerablenya. Lalu bagaimana caranya untuk hide server tokens di nginx ? Caranya kalian bisa menambahkan `server_tokens off` didalam file `nginx.conf` nya

```conf
...

http {
    ...
    server_tokens off;
}
```
Nanti jika sudah melakukan hal tersebut maka version dari nginx tidak akan tertampil lagi dan akan seperti ini
<img src="https://owlhowto.com/content/images/size/w600/2021/07/server_tokens_off_active.png">

## Resource Limit
Nginx kalian bisa mengatur sesuka kalian sesuai kebutuhan kalian, kalian bisa mengatur maximal open koneksi ke server nginx, maximal untuk time to live koneksi ke nginx, bahkan maximal size request yang kalian kirim. Hal ini dilakukan untuk pencegahan adanya sebuah penyerangan seperti `DDOS` karena dengan dilakukanya request dalam size yang besar akan membuat server down dan hal itu membuat server akan mengalami recover sejenak. Lalu apa saja yang bisa di atur didalam nginx ? 

```conf
...

http {
    ...
    # ini untuk set maximal body yang bisa dikirim ke nginx
    # biasanya ini untuk method POST a.k.a mengirim data ke server
    client_max_body_size 600M;

    # ini waktu untuk time to live sifatnya dia per second
    keeaplive_timeout 180;

    # ini untuk mengatur buffer body size
    # ini lebih spesifik ke satu client secara default itu 8k
    client_body_buffer_size 1k;

    # ini untuk mengatur buffer dari header size
    # sama hal nya dengan body buffer size ini spesifik ke satu client
    client_header_buffer_size 1k;
}
```
Nah diatas adalah sample contoh konfigurasi nginx, hal ini dilakukan agar ketika client yang berusaha melebihi batas request akan gagal. Ini kerap kali dilakukan oleh para tim development ketika menggunakan nginx sebagai `api gateway`

## Worker Limit
Worker limit ialah hal perlu dimanagement ini diatur agar processor yang dimakan oleh cpu tidak terlalu over dan bisa dialokasikan untuk ke aplikasi yang dipublish. Selain itu worker limit juga mengatur batasan jumlah koneksi yang open ke nginx, hal ini salah satu cara untuk mencegahnya aplikasi menjadi over request . Lalu bagaimana cara handlingnya ? kalian bisa tambahkan ini di konfigurasi kalian

```conf
# jumlah processor yang dipake
worker_processes 1;

# error logging, kalian bisa ubah ke crit atau info
error_log /var/log/nginx-error.log info;

events {
    # ini adalah worker connection atau jumlah maximal tampungan client yang bisa koneksi ke nginx
    worker_connections 1024;
}
```

## Web Application Firewall
WAF atau Web Application Firewall sebelumnya kita pernah bahas hal ini . Mungkin kita review balik, WAF sering digunakan untuk menganalisis yang terjadi dalam web server kita. WAF open source dan kalian gratis memakainya. Keuntungann dari WAF kita bisa tahu siapa yang melakukan request dan probability penyerangan yang dilakukan. Salah satunya seperti contoh dibawah ini 

<img src='https://media.discordapp.net/attachments/856833008761700362/932554992299159552/unknown.png?width=873&height=122' />

Diatas telah terjadinya penyerangan dengan metode LFI. Berbeda dengan apache2 kita harus melakukan beberapa step untuk memasang ModSec di NGINX berikut caranya

> Pertama install dependecy yang diperlukan
```bash
apt-get install -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev
```

> Kedua cloning github ModSecurity
```bash
git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity
```

> Ketiga step untuk konfigurasi ModSecurity
```bash
cd ModSecurity
git submodule init
git submodule update
./build.sh
./configure
make
make install
cd ..
```
> Keempat download nginx connector untuk ke Modsecurity
```bash
git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git
```

> Kelima check version nginx yang sudah ada
```bash
nginx -v
```

> Keenam kalian bisa download version nginx yang sesuai , disini versi saya 1.13.1
```bash
wget http://nginx.org/download/nginx-1.13.1.tar.gz
tar zxvf nginx-1.13.1.tar.gz
```

> Ketujuh, kalian bisa compile module yang udah diclone dengan cara seperti ini
```bash
cd nginx-1.13.1
./configure --with-compat --add-dynamic-module=../ModSecurity-nginx
make modules
cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules
cd ..
```
Lalu kalian bisa load modules nya didalam file `/etc/nginx/nginx.conf` kalian, dengan menambahkan `load_module modules/ngx_http_modsecurity_module.so;` setelah itu baru kalian harus enable modsecurity 

```bash
mkdir /etc/nginx/modsec
wget -P /etc/nginx/modsec/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
mv /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf
cp ModSecurity/unicode.mapping /etc/nginx/modsec
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf
```
Nah kalau sudah ikuti step step diatas modsecurity kalian sudah berjalan. Gimana panjang bukan ? yaa memang untuk konfigurasi modsecurity di nginx itu cukup panjang. Kalau kalian mau tahu lebih detail kalian juga bisa ke docs nya nginx [Install Modsec di NGIMX](https://www.nginx.com/blog/compiling-and-installing-modsecurity-for-open-source-nginx/)