# Secure Shell
Yap `secure shell` atau disebut dengan ssh. Merupakan tools yang digunakan untuk remote server. Secara default ssh server memiliki port sendiri yaitu port `22`. SSH kerap kali digunakan untuk untuk komunikasi antar server. Bahkan ketika kalian membeli vps secara default kalian harus mengisi password dan public key ssh itu sendiri. Lalu apa saja cara kita untuk hardening SSH server itu sendiri ? Nah berikut cara yang bisa kalian terapkan untuk hardening ssh server kalian. Sebelum itu pastikan kalian punya ssh server terlebih dahulu, jika belum ada kalian bisa install dengan cara seberti ini 

- Debian/Ubuntu
    ```
    $ sudo apt install openssh-server -y
    ```

- Alpine Linux 
    ```
    $ sudo apk add openssh
    ```

- CentOS
    ```
    $ sudo yum install openssh-server
    ```

### PermitRootLogin
Pertama, jangan sampai root diberi akses untuk login ke ssh server. Root merupakan kasta tertinggi dalam dunia peruseran, jika akses root telah didapatkan maka semua apapun bisa dilakukan. Mau remove user, move directory, bahkan ubah permission dari setiap folder dan user yang ada. Kalian bisa ubah itu di `/etc/ssh/sshd_config`

```
PermitRootLogin No
```

### MaxAuthTries
MaxAuthTries ialah setup yang dilakukan untuk membatasi maximal mencoba login ke ssh server jika mengalami kegagalan, misal seperti memasukan password yang salah. Ini jadi media yang bisa lakukan untuk ban ip address yang melakukan terhubung ke server kita jika lebih dari batas maximal

```
MaxAuthTries 3
```
Secara default itu 3, namun kalian bisa atur lebih besar dari default atau lebih rendah, sesuaikan selera kalian

### PermitEmptyPasswords
PermitEmptyPasswords dilakukan untuk setup jika tidak diperbolehkan untuk passwordnya kosong. Disini kalian tinggal tambahkan statement `no` saja makaa otomatis konfigurasi berjalan

```
PermitEmptyPasswords no
```

### X11Forwarding
X11Forwarding ialah SSH protocols yang dimana membuat remote server secara graphical ke server yang dituju. Sebenarnya ini jarang sekali yang memakainya, namun kalau memang tidak mau digunakan lebih baik disable saja dengan cara `X11Forwarding no`

```
X11Forwarding no
```

### AllowUsers
AllowUsers membuat server jauh lebih strict dimana servernya hanya memperbolehkan ip tertentu atau user server tertentu yang bisa digunakan untuk di remote servernya. Cara konfigurasinya dengan cara seperti ini

```
AllowUsers example@192.168.0.0/24
```

### PublicKey
Ini cara yang sering digunakan, di local laptop kita membuat ssh-keygen dan dari `id_rsa.pub` dan nanti bisa di masukan ke dalam `authorized_keys` server itu sendiri. Hal ini digunakan agar hanya laptop mu sendiri yang bisa konek ke server tersebut

```
ssh-keygen -t rsa
```
Habis itu kalian bisa ke folder `$HOME/.ssh`, nanti ada file `id_rsa.pub` yang bisa kalian copy ke server kalian atau kalian bisa gunakan dengan cara ini

```
ssh-copy-id -i .ssh/id_rsa.pub [USER]@[IP_ADDRESS_SERVER] -p [PORT]
```

### PasswordAuthentication
Berhubung kalian setup public key , kalian juga bisa disable `PasswordAuthentication` agar nanti ketika terhubung pasti akan dianjurkan untuk memakai public key, kalian bisa tambahkan di `/etc/ssh/ssh_sshd`

```
PasswordAuthentication no
```

### Custom Port
Berhubung range port dari `1-8080` itu masih bisa di scan sama network mapper, kalian bisa custom port dari ssh server itu sendiri. Diusahakn custom nya di range `10000-65535` agar tools network mapper tidak bisa membaca port nya. Kalian bisa custom port ini di file `/etc/ssh/sshd_config`

```
Port 25643
```