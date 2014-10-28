ipaccess
========
Labels
Apache, logs, Control, Delphi, Pascal, jamesjara

For next defcon control any spy on you,Ip Access tool is a special program to control ips, logs and apache web server logs!
Ip Access tool is a special program to control ips, logs and apache web server logs!


IMAGES

![](http://1.bp.blogspot.com/_GJSc3wdEDz0/Sipezt5SciI/AAAAAAAAASU/PQ-7eJqoedo/s1600/ipaccess.JPG)


video:
http://www.youtube.com/watch?v=9elCWH976os&feature=player_embedded 


*What is IP Access?*
Ipaccess is software to control ips entering the web server apache in this case. The difference to many control systems, logs and maintenance of servers that are not in real time,  IpAccess is real-time, you can display alerts, sounds, messages, events at the same time a host enters to the server ip. Runs in trayicon 

*for Who IpAccess ?*
Is for common and advanced users with servers 'private' where anyone can enter, this serves to prevent such unauthorized access. When I refer to users means that there is a program for web pages where visitors arrive daily inamginate thousand thousand alert! wtff noop .... is for home server, servers, server testing, special servers, web servers temporary. etc.

*What does and what does?*
1 - From: creates a record of each access to the data: ip, date, time, mac, referring page, current page, browser, operating system.
2 - Used to control access to the apache server, as its name says it detects the ip access.


*How does IP Access?*
1 - The operation is running way behind background is not necessary to have the window always on front not! .. Ip ip access control is connected to a temporary database in which save each record ....
[http://2.bp.blogspot.com/_GJSc3wdEDz0/SipjQ_qSqHI/AAAAAAAAASk/K7ufjui5qdk/s400/ip-access.JPG]


*Ip Access is not?*
Again ,not for web servers with millions of hits a day, you can easily convert But, this version nop.
It is a traffic analysis program apache log but its purpose has nothing to do with analysis.

*Requirements?*
need:
1 - Web Server (apache, iis)
2 - Module php or asp
3 - Microsoft operating system

*You have another web server or language?*
Okay if so, please ask me a very simple and I will develop the library for your respective language or clear can do it yourself, but do not forget to share with us XDDD!

*How to install and configure?*
1 - You open the installer you give everything you choose the address below where you want to put it and when you open ends.
2 - You go into the Config folder files, copy the folder IpAccess, your Apache or IIS Web server, or that SEAA, then paste it on your server exactly the root bone in the main part .. this folder will never be accessed manually.
3 - Open the file with any editor control.php find the line where this variable
```php
// path to database
$rutadb = "&Ip Access";
```
and there put the path in our Ipaccess remember going without the last slash /.
4 - Implementation: You can deploy it on every page but do not need it just to put the main page or file that connects to your database so it only has to see and not just 1 paste the code in all your pages ...
```php
include ('IpAccess / control.php');
?>
```
5 - Well, we http://localhost/ test, and if not show any mistake then fine, otherwise repeat steps or posteame error. Sometimes there are problems with trying to put the path 
```php
// double slash eg 
$rutadb = "D: \ \ xxx \ \ xxxx xxxx \ \ Ip Access", and try over again.
```


http://3.bp.blogspot.com/_GJSc3wdEDz0/SipgJxazXII/AAAAAAAAASc/4TLGOV0oumg/s1600/ipaccess-2.JPG


