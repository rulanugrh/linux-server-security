<h1 align='center'>Apache2 Hardening</h1>


Oke kali ini saya akan membahas tentang keamanan dasar `Apache`, dan untuk tingkat lanjutannya akan saya pisahkan sendiri. Sebelum itu mari kita kenali dulu, apa itu Apache?. Oke sebenarnya apache itu luas, sekarang yang kita bahas adalah apache httpd. `Apache HTTPD` merupakan jenis `Web Server` yang berfungsi sebagai media untuk menampilkan source code yang telah kita buat. `Apache HTTPD` perlu diamankan jika tidak dilakukan maka dapat dipentest melalui banyak cara. Mengamankan apache2 adalah salah satu bentuk patching terhadap aplikasi yang berjalan di server. Maka dari itu, mari kita bahas hardening di `Apache HTTPD` 

Index Directory
=================
<img src='https://i.stack.imgur.com/6CFFq.png /'>

Nah ini naamanya directory listing, biasanya ada yang sering menggunakan ini untuk publish beberapa media yang diperlukan, atau sharing file terhadap orang lain. Namun hal ini bisa jadi panah untuk ke server kita, karena dengan kata lain jika terdapat beberapa hal penting seperti `.env` dan file `migration` itu akan bisa langsung dibuka oleh publik. Lalu bagaimana caranya untuk patching hal tersebut ? Simpel aja, kalian bisa mengubah beberapa hal di `apache2.conf` terutama di section konfig dibawah ini

```apache
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
```
Kalian bisa mengubah menjadi seperti dibawah ini untuk membuat section selain dari root folder dan struktur web ( seperti html / php ) akan di forbidden
```apache
<Directory /var/www/>
        Options -Indexes -FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
```
Dan hasilnya akan seperti ini nantinya

<img src="https://media.discordapp.net/attachments/856833008761700362/932088232894681118/unknown.png?width=515&height=195" />

Jadi seperti inilah cara untuk patching directory listing di apache2

Signatures & Tokens
===================
Okay selanjutnya adalah tentang server signature dan server tokens. Kedua hal ini sering sekali keluar ketika pertama kali install web server baik `apache2` atauapun web server lainnya . Lalu seberapa riskan-nya si kalau ini di publish ?

<img src="https://www.xmodulo.com/img/153a.png">

Kita ambil contoh seperti diatas yaitu web server dengan versi `Apache/2.2.22 (Debian) Server`. Dan telah diketahui juga ip address dari server tersebut dan port nyaa. Nah yang terjadi informasi tentang versi debian dan ip server ke-publish. Selain itu memicu yang lainnya juga seperti dibawah ini

<img src='https://media.discordapp.net/attachments/1153331597727236108/1201719422184595487/image.png' />

Yang dimana ini merupakan salah satu bentuk SSRF (Server Side Request Forgery ) Lalu cara patchingnya bagaimana? Simple saja kalian tinggal ubah `ServerSignature` ke `Off` dan `ServerTokens` ke `Prod` dan ini bisa kalian tambahkan kedalam `httpd.conf` jika kalian memakai CentOS, `apache2.conf` atau `security.conf` jika kalian memakai Debian/Ubuntu
```apache
ServerSignature Off
ServerTokens Prod
```

Web Aplication Firewall
=======================
Oke selanjutnya adalah WAF atau bisa disebut dengan Web Application Firewall. WAF sering digunakan untuk menganalisis yang terjadi dalam web server kita. WAF open source dan kalian gratis memakainya. Keuntungann dari WAF kita bisa tahu siapa yang melakukan request dan probability penyerangan yang dilakukan. Salah satunya seperti contoh dibawah ini 

<img src='https://media.discordapp.net/attachments/856833008761700362/932554992299159552/unknown.png?width=873&height=122' />

Diatas telah terjadinya penyerangan dengan metode LFI. Nah lalu bagaimana cara kita memakainya di `apache2` gampang kalian tinggal install menggunakan `apt` saja jika memakai Debian/Ubuntu, atau kalian bisa juga mengikuti sesuai arahan di githubnya [ModSecurity](https://github.com/owasp-modsecurity/ModSecurity)

```bash
apt update -y
apt install libapache2-mod-security -y
```

Setelah diinstall, kalian bisa ke folder `/etc/modsecurity/` lalu ubah file ini `modsecurity.conf-recommended` menjadii `modsecurity.conf` , lalu ubah `SecRuleEngine` menjadi `On`

```bash
cd /etc/modsecurity
mv modsecurity.conf-recommended modsecurity.conf
nano modsecurity.conf
......

# -- Rule engine initialization ----------------------------------------------

# Enable ModSecurity, attaching it to every transaction. Use detection
# only to start with, because that minimises the chances of post-installation
# disruption.
#
#SecRuleEngine DetectionOnly
SecRuleEngine On
```
