<h1 align='center'>Firewall in Ubuntu</h1>
<div align='center'>
    <img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwallpapercave.com%2Fwp%2Fwp2761621.gif&f=1&nofb=1" />
</div>

Oke firewall adalah metode yang digunakan untuk mengamankan sistem server kita. Mengapa ini penting?, karena seperti ini misalkan kita mempunyai server yang bagus, dari sudut pandang FrontEnd yang bagus, setupnya bagus tapi keamanannya buruk, percuma karena mungkin ada yang ingin menyerang server kita. Oke maka dari itu saya ingin menjelaskan tentang firewall di ubuntu. Salah satu firewall yang ada di ubuntu adalah iptables, dimana iptables berperan penting dalam mengatur keamanan sistem, sederhananya iptables ini bekerja dengan memasukkan `rule`, lalu bagaimana cara menggunakannya? apa aturannya? Oke, simak berikut ini.

Getting Started
=================
Sebelum itu mari kita bahas rule dimana rule ini memegang peranan penting dalam membangun firewall. Secara sederhana aturan di iptables ini sama dengan `persyaratan` untuk masuk/akses dari komputer client ke server kita. Oke, mari kita kenali tentang perintah dasar iptables.
```
iptables -nvL => Command ini digunakan untuk melihat rule yang sudah kita buat
iptables -A   => Command ini untuk append rule baru ke dalam system
iptables -I   => Command in iuntuk insert rule ke column pertama
iptables -D   => command ini sering digunakan untuk delete rule iptables
iptables -P   => command ini serign digunakan untuk insert secara default policy
iptables -F   => command ini untuk flush / reset iptables
```
Nah selanjutnya apa si itu `CHAIN`, ini lebih sering disebut dengan aturan yang mau dipake, Setiap `MODE` itu memiliki `CHAIN` yang berbeda untuk sekarang kita ke `FILTER RULES` terlebih dahulu, next akan lebih mendalam lagi pembahasannya:
```
INPUT   => ini untuk input rule atau request dari client
OUTPUT  => chain ini untuk response terhadap client yang request
FORWARD => chain ini sering digunakan untuk meneruskan paket ketika melewati router
```
`JUMP` merupakan allowed / not allowed rules yang harus dipahami ketika memakai iptables, ada beberapa `JUMP` yang sering digunakan , seperti dibawah ini
```
ACCEPT   => digunakan untuk membuka port
DROP     => digunakan untuk drop port / block port
LOG      => digunakan untuk membuat log dari port yang diterapkan
REJECT   => digunakan untuk reject port yang ingin terkoneksi ke server
REDIRECT => digunakan untuk redirect port dari port yang telah ditentukan
```
Fyi, ada cara untuk kalian save rules iptables kalian dengan cara `iptables-save > name_file` atau `iptables-restore < name_file` untuk restore rules yang telah di konfigurasi

Usage
=====
Okayy, sung aja kita bahas beberapa command yang sering digunakan untuk meng-operasikan iptables
```
iptables -I INPUT -p icmp -j ACCEPT
iptables -I OUTPUT -p icmp -j ACCEPT
```
> Command diatas digunakan untuk allow port icmp baik ketika request ataupun response dari server
```
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
```
> Sama dengan yang diatasnya ini juga untuk allow port 80 baik request ataupun response dari server
```
iptables -D INPUT -p tcp --dport 80 -j ACCEPT
iptables -D OUTPUT -p tcp --sport 80 -j ACCEPT
```
> Command ini digunakan untuk delete rule INPUT port 80 dan OUTPUT nya
```
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
iptables -I OUTPUT -p tcp --sport 22 -j ACCEPT
```
> Command ini membuat port 22 menjadi prioritas
```
iptables -A INPUT -p tcp --dport 21 -j DROP
iptables -A INPUT -p tcp --sport 21 -j DROP
```
> Command diatas digunakan untuk block yang melakukan request ke port 21 dan response dari port 21

Nahh, inilah cara kalian untuk meng-operasikan sebuah iptables. Oya sebelum itu diatas ada beberapa `flag` yang sering keluar seperti `--dport` yang artinya adalah `destination port` dan `--sport` yang artinya `source port`. Untuk `-p` ini untuk type port yang ingin diinput, ada banyak jenis port kalian bisa cari di [wikipedia](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) `tcp, icmp, udp, etc`
