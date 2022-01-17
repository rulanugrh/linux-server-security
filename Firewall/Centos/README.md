<h1 align='center'>Firewall in CentOS</h1>
<div align='center'>
    <img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwallpapercave.com%2Fwp%2Fwp2761621.gif&f=1&nofb=1" />
</div>

Okay, then the firewall on CentOS. Is it the same as the one on ubuntu? or is it more difficult? Of course it's different from `iptables` where the firewall on CentOS is much more complex and how to use it based on the `zone` that has been created / defined. Then what to wear? yup, it is firewall-cmd where a software firewall on CentOS is used to secure the system. Ok wait a minute, can't you use iptables? you can just install `iptables-persistent` only this is less effective on CentOS. However, there is something unique in CentOS where when we don't enter a rule in the firewall, the service that we create will not run / automatically closed

Getting Started
===================
Okay, for this session, at least not much. I will discuss only zones and a few commands. Okay, look at the following, first we will discuss what zones are on CentOS
```
DROP     => This is a zone that really doesn't trust any connection, usually those who want to connect with this will be rejected
BLOCK    => Same as drop, only the difference is that the block sends like an icmp-prohibited message, if you know IPTABLES Jump REJECT, it's the same as that
PUBLIC   => Default zone or default zone when we want to set a firewalld, this depends on the gateway ip, and the interfaces of a connection
EXTERNAL => Okay for this configuration which is intended for NAT which logically when we NAT then the IP gateway that we NAT will be able to access it
INTERNAL => Where is devoted to internal gateway connections only
DMZ      => This particular connection is only allowed, the same as creating a new zone
WORK     => This zone is intended to be used for work machines. Other systems on this network are generally trusted.
HOME     => This zone is intended to be used for home machines. Other systems on this network are generally trusted.
TRUSTED  => A firewall that trusts any connection
```
Okay, we've discussed what zones are in firewall-cmd , then how does it operate and how to use it. Maybe I will first discuss the important commands in firewall-cmd
```
firewall-cmd --list-all-zone         => To see rules for all zones
firewall-cmd --get-default-zone      => To see our default zone
firewall-cmd --set-default-zone=drop => Setting the default zone to drop
firewall-cmd --new-zone=ubuntu       => To create a new zone
```

Usage
=====
Okay above, the important commands in firewall-cmd have been explained, let's go, we will discuss how to use them
```
firewall-cmd --add-service=ftp --permanent
```
> The above command is used to add an ftp firewall permanently
```
firewall-cmd --add-port=8080/tcp --permanent
```
> Where serves to add rules for ports permanently usually used when there is a service
```
firewall-cmd --zone=drop --add-service=dns --permanent
```
> Explains that the dns service enters the drop zone which will automatically not be able to access a dns
```
firewall-cmd --zone=truster --add-source=192.168.0.1/24 --permanent
```
> The above command explains that the truster zone has added a source address to permanently access the 192.168.0.1 network

Anyway, when you want to use a `firewall-cmd`, don't forget to first enable `systemctl enable firewall-cmd`, then start `systemctl start firewall-cmd` and save it with `systemctl restart firewall-cmd

LICENSE
=======
Distributed under the MIT License. See [`LICENSE`](https://github.com/ItsArul/Security/blob/main/LICENSE) for more information

> Note : For more advanced commands, they will be discussed in the advanced section, here I only explain the basic commands and understanding before going to advance
