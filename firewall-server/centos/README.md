<div align='center'>
    <img src="../../.github/asset/centos.png" />
</div>

## Getting Started
Oke, kalau begitu firewall di CentOS. Apakah sama dengan yang ada di ubuntu? Atau lebih sulit? Tentu saja berbeda dengan `iptables` dimana firewall pada CentOS jauh lebih kompleks dan cara menggunakannya berdasarkan `zone` yang telah dibuat/ditentukan. Lalu apa yang harus dipakai? yup, itu adalah firewall-cmd di mana firewall perangkat lunak pada CentOS digunakan untuk mengamankan sistem. Ok tunggu sebentar, apakah kita bis menggunakan iptables? Kita bisa saja menginstal `iptables-persistent` hanya saja ini kurang efektif di CentOS. Namun, ada sesuatu yang unik di CentOS dimana ketika kita tidak memasukkan aturan di firewall, layanan yang kita buat tidak akan berjalan/otomatis ditutup


Oke, untuk sesi ini, setidaknya tidak banyak. Saya hanya akan membahas zona dan beberapa perintah. Oke simak berikut ini, pertama kita akan membahas apa saja zona yang ada di CentOS
```
DROP     => Ini adalah zona yang sangat tidak mempercayai koneksi apapun, biasanya yang ingin terhubung dengan ini akan ditolak
BLOCK    => Sama seperti drop, hanya saja bedanya blok tersebut mengirim seperti pesan icmp-prohibited message, jika anda tahu IPTABLES Jump REJECT, sama saja seperti itu
PUBLIC   => Default zone atau zona default ketika kita ingin mengatur firewalld, ini tergantung pada ip gateway, dan antarmuka koneksi
EXTERNAL => Oke untuk konfigurasi ini yang ditujukan untuk NAT yang mana logikanya bila kita NAT maka IP gateway yang kita NAT akan bisa mengaksesnya
INTERNAL => Dimana dikhususkan untuk koneksi gateway internal saja
```
Dan masih banyak lagi, seperti WORK, HOME, TRUSTED. Namun kebanyakan lebih memilih untuk custom firewall-cmd nya sesuai keinginan masing-masing karena lebih efisien dalam memanagementnya, lalu apa saja command yang ada di `firewall-cmd ini`
```
firewall-cmd --list-all-zone         => Ini command untuk melihat semua zone
firewall-cmd --get-default-zone      => Ini untuk melihat rule di default zone
firewall-cmd --set-default-zone=drop => Ini setup baru untuk default zone
firewall-cmd --new-zone=ubuntu       => Lalu ini membuat custom zona baru
```

Usage
=====
Nah dibawah ini ada beberapa command yang penting untuk kalian ketahui dalam konfigurasi `firewall-cmd`
```
firewall-cmd --add-service=ftp --permanent
```
> Command ini untuk menambahkan rule ftp kedalam zona
```
firewall-cmd --add-port=8080/tcp --permanent
```
> Command ini untuk menambahkan port 8080 kedalam zona
```
firewall-cmd --zone=drop --add-service=dns --permanent
```
> Command ini untuk menambahkan dns ke zona drop
```
firewall-cmd --zone=trusted --add-source=192.168.0.1/24 --permanent
```
> Command ini untuk menambahkan network `192.168.0.1/24` ke dalam zona `trusted`, command ini diperuntukan allow connection ke zona yang ditentukan

Sebelum kalian menggunakan `firewall-cmd`, jangan lupa enable terlebih dahulu `systemctl enable firewall-cmd`, lalu start system `systemctl start firewall-cmd` dan restart systemnya `systemctl restart firewall-cmd
