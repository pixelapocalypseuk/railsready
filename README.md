Rails Ready
===========

Rails Ready is a collection of two scripts originally authored by Josh Frye - it handles setting up a server with RVM or system ruby, database servers, rubygems, database servers - basically everything you need to get off the ground and running with Ruby on Rails on Ubuntu and CentOS

Rails Ready Ready (Witty name pending)
======================================

Rails Ready Ready is a script authored by Josh McArthur that handle getting a server ready for any web server use, but intended to be run prior to Rails Ready on a brand-new VPS or server. Starting from the root account, it handles creating a lower-priviledge account with sudo access for day-to-day use, setting up a secure running instance of SSH for remote login, and configuring Linux's basic firewall `iptables` to block unnecessary ports and create a secure web server - all the mundane stuff that needs to be done when setting up a new server.

Supported distros
-----------------

* Rails Ready Ready only supports Ubuntu Server 10.04 LTS and above - CentOS/Fedora and Redhat, etc is pending - I need to know more about that architecture of these distributions, but in the meantime, pull requests are welcomed.
* Rails Ready supports Ubuntu Server 10.04 and above, and CentOS 5.5

Caution
-------

Both Rails Ready and Rails Ready Ready WILL update your system. Before you begin, make sure you take a snapshot or other backup, and make sure you understand what these scripts are doing before you run them.

Use
---

* **RailsReady Ready:** `wget --no-check-certificate https://raw.github.com/3months/railsready-ready/master/railsreadyready.sh && bash railsreadyready.sh`
* **RailsReady:** `wget --no-check-certificate https://raw.github.com/3months/railsready-ready/master/railsready.sh&& bash railsready.sh`


Once you've run both scripts:
-----------------------------

Just install either NGINX or Apache, run passenger-install-nginx-module or passenger-install-apache-module, upload your app, point your vhost config to your apps public dir and go!

Please note: If you are running on a super slow connection your sudo session may timeout and you'll have to enter your password again. If you're running this on an EC2 or RS instance it shouldn't be problem.

License
-------

Both RailsReady Ready and RailsReady are MIT licensed - hack away, and pull request back to help out!
