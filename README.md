#there4-vagrant
==============

##Boilerplate Vagrant Setup

Get a simple apache, mysql, php stack running very quickly.

##How to use

Simply copy over the `vagrant` folder and the `Vagrantfile` to your web project.
Update the configuration as you choose (see below). Type `vagrant up` on the
command line to initialize the set up.

By default the vagrant virtual machine will create a shared link with your
project root and will point the apache web root of the virtual machine to the
`web` folder in the base of your project.  (Don't like the web folder?
You can change that in the apache config file.)

The vagrant virtual machine will be available at `http://33.33.33.100`

You can access the mysql database by pointing your client of choice
at `33.33.33.100:3333`

##Features

###Apache Server

Apache config is located in `vagrant/resources/app/etc/apache2`.
By default is supports `.htaccess` overrides so your projects can just plug
in and work.

Apache server logs will be placed in `vagrant/log`

###PHP Install

php.ini file is located in `vagrant/resources/app/etc/php5`.
Drop in your preferred php.ini file and server will adhere to your settings.
The defaults favor a dev environment set up. (Currently provisioning doesn't
load any non-standard extensions to php.)

###MySql Server

mysql config is located in `vagrant/resources/app/etc/mysql`

By default the database will be initalized to be empty.  You can use your own
custom sql initialization by replacing the contents in `vagrant/data/init.sql`
