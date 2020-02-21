# wpinit
This is a wordpress install script I use to automate wp setup on my machines. Currently this repo is meant for wprig based setup, but I plan to add one for underscores theme and for enfold theme, either as options in the same script or as additional scripts

## What does it do?
* Downloads latest WP
* Removes stock themes and plugins
* Installs wprig "theme"
* Installs migrate db, classic editor and show current template
* Puts htaccess, robots and humans files in wordpress root
* Creates wordpress database and edits wp-config db data and puls generated hashes in it

## Also
* I made this for my own use ... so use if you like ... but thats it
* On location promt enter dot if you want to install in current directory
* Remove, change or add anything you like
* At the end it requires sudo for DB creation
* Vagrant setups mught be better in general, my debian workstation has apache and mysql allready setup, so it is faster and simpler to do it like this

* Enjoy