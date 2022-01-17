<h1 align='center'>Apache Hardening</h1>
<div align='center'>
    <img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fgifimage.net%2Fwp-content%2Fuploads%2F2017%2F09%2Fanime-wallpaper-gif-7.gif&f=1&nofb=1" />
</div>

Okay, this time I will discuss the basic security of `Apache`, and for the advanced level I will separate it myself. Before that, let's get to know , what is Apache?. Okay, actually apache is broad, now what we are discussing is apache httpd. `Apache HTTPD` is a type of `Web Server` which functions as a medium to display the source code that we have created. `Apache` itself also needs to be secured where if it is not done then it can be pentested through the `Apache` application. Anyway, when securing apache is one form of righting an application. So that's it for an explanation about apache. Next let's discuss hardening in `Apache HTTPD`

Index Directory
=================
<img src='https://i.stack.imgur.com/6CFFq.png /'>

Has anyone seen this? At first glance, it looks like it's just normal, there's nothing to harden. But let's think further, for example, in our directory there are important things, for example our data environment and then we forget to turn off the `index directory` , it will have a bad impact on our server. For example, in our `laravel` project, we have `env` where there is a `password & user database`, they can automatically attack our database. Then how to secure it?. Watch this

```apache
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
```
Now this is where we have to secure it, by adding `-Indexes -FollowSymLinks` to make this forbidden
```apache
<Directory /var/www/>
        Options -Indexes -FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
```
OK, don't believe me? this is an example when it has been made `-Indexes -FollowSymLinks`

<img src="https://media.discordapp.net/attachments/856833008761700362/932088232894681118/unknown.png?width=515&height=195" />

OK, that's the hardening method of the Index Directory, is there anything else next? yes of course there is

Signatures & Tokens
===================
Okay, next to the signature here, the signature plays an important role in securing an apache2 application. So, what is meant by a signature? The signature in rough language is like the version on our web-server, for example, like this

<img src="https://www.xmodulo.com/img/153a.png">

There has been assigned the signature and the tokens are `Apache/2.2.22 (Debia) Server`. Sometimes this triggers a vulnerability in an apache web-server. How come, how do you find it? This can be searched by the version of the web-server, for example

<img src='https://media.discordapp.net/attachments/856833008761700362/932523441754632212/unknown.png?width=758&height=310' />

Then how to secure it? Change `ServerSignature` to `Off` and `ServerTokens` to `Prod` in `httpd.conf` for CentOS and relatives or `apache.conf` and `security.conf` for Debian/Ubuntu.
```apache
ServerSignature Off
ServerTokens Prod
```

Web Aplication Firewall
=======================
OK, what is a web application firewall? The outline of WAF is a software that is useful for securing our applications. Then what is WAF? Actually, there are many WAFs, maybe this time I will discuss an open source WAF, namely `ModSecurity`. `ModSecurity` is an open source WAF, modsecurity or what is often called modsec is very good for security, where it can detect attacks that occur, for example like this

<img src='https://media.discordapp.net/attachments/856833008761700362/932554992299159552/unknown.png?width=873&height=122' />

It has been explained there that the vulnerability is LFI or Local File Inclusion where the vulnerabilities can see local files inside us. Then how to get `ModSecurity`? easy we just install using `apt`

```bash
apt update -y
apt install libapache2-mod-security -y
```
Then after installing, edit the file section, to know where the file is, bro? in the `/etc/modsecurity/` directory then change the `modsecurity.conf-recommended` file to `modsecurity.conf` , then change `SecRuleEngine` to `On`

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

LICENSE
=======
Distributed under the MIT License. See [`LICENSE`](https://github.com/ItsArul/Security/blob/main/LICENSE) for more information

> Note : For more advanced commands, they will be discussed in the advanced section, here I only explain the basic commands and understanding before going to advance
