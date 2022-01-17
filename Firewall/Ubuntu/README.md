<h1 align='center'>Firewall in Ubuntu</h1>
<div align='center'>
    <img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwallpapercave.com%2Fwp%2Fwp2761621.gif&f=1&nofb=1" />
</div>

Okay firewall is a method which is used to secure our server system. Why is this important?, because like this, for example, let's say we have a good server, from a good FrontEnd perspective, the setup is good but the security is bad, it's useless because someone might want to attack our server. Okay that's why I want to explain about the firewall in ubuntu. One of the firewalls in ubuntu is iptables, where iptables plays an important role in managing the security of the system, simply this iptables works by entering a `rule`, then how to use it? what are the rules? OK, look at the following.

Getting Started
=================
Before that, let's discuss the rule where this rule plays an important role in building a firewall. In simple terms, this rule in iptables is the same as the 'requirements' to enter / access from the client computer to our server. Okay, let's get to know about the basic iptables commands.
```
iptables -nvL => is used to display the list of iptables that we have created
iptables -A   => is used to add a rule to the iptables list
iptables -I   => is used to prioritize entering a rule into iptables
iptables -D   => used to delete rules in iptables
iptables -P   => is used to insert a rule into the default policy
iptables -F   => used to flush / reset iptables rules
```
Next, let's talk about `CHAIN`. Chain is as simple as a description in building a firewall with iptables. Then what's going on?, let's go:
```
INPUT   => chain used to enter a rule input into iptables
OUTPUT  => chain used to enter an output rule into iptables
FORWARD => chain that is used to enter a forward rule, usually this is used to forward a message / port to another server
```
Besides chain, there is another thing called 'JUMP', where jump is the keyword in building a firewall, roughly speaking, this jump is the same as 'permissions' in building rules in iptables
```
ACCEPT   => jump used to accept this port/rule is open
DROP     => jump which is used to close the port/rule
LOG      => jump which is used to make a port/rule into LOG
REJECT   => jump used to reject a port/rule
REDIRECT => jump which is used to redirect port to another port
```
Anyway, for saving rules in a file you can use the command `iptables-save > name_file` or `iptables-restore < name_file` which is used to restore a rule

Usage
=====
Okay, let's discuss how to use it, for how to use it maybe while I explain the flow
```
iptables -I INPUT -p icmp -j ACCEPT
iptables -I OUTPUT -p icmp -j ACCEPT
```
> Where serves to make the `icmp` port open and all clients can ping our server
```
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
```
> OK, the port above is an `accept` rule where the system accepts port 80 to access
```
iptables -D INPUT -p tcp --dport 80 -j ACCEPT
iptables -D OUTPUT -p tcp --sport 80 -j ACCEPT
```
> The above command is a command to delete a rule in iptables, this command is very important when we want to delete a rule
```
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
iptables -I OUTPUT -p tcp --sport 22 -j ACCEPT
```
> Command that prioritizes port 22 into the iptables rule
```
iptables -A INPUT -p tcp --dport 21 -j DROP
iptables -A INPUT -p tcp --sport 21 -j DROP
```
> Command which serves to close port 21 for publishing

Okay, maybe how to use it like this, the rest you explore where I have explained above. Anyway, from earlier there was a `--dport` command which functioned for `destination port` and there was `--sport` which functioned for `source port`. For `-p` itself this is a marker of the type of port, such as `tcp, icmp, udp, etc`

LICENSE
=======
Distributed under the MIT License. See [`LICENSE`](https://github.com/ItsArul/Security/blob/main/LICENSE) for more information

> Note : For more advanced commands, they will be discussed in the advanced section, here I only explain the basic commands and understanding before going to advance
