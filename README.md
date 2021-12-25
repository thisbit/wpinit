# wpinit
This repo contains a wordpress install and uninstall scripts that I use daily on my Linux box. It can work with OSX too with slight modifications, but there I find it makes more sense to use http://vagrantup.com with http://vccw.cc instead of this. On a Mac I use Local By Flywheel, as it is one clisk install and has blueprints. If it isn't obvious from file names, riginit.sh is the installer and rigrm.sh is the uninstaller. I plan to simplify and extend the functionality of the files in repo as I find time and learn more.

## What does it do?
* Downloads latest WP
* Removes stock themes and plugins
* Installs either: a starter theme wprig, "underscores _s" or understrap or it installs enfold theme and creates the child theme for it (requires one to purchase enfold and download it so it is available locally)
* Installs migrate db, classic editor and show current template
* Puts my custom htaccess, robots and humans files in wordpress root
* Creates wordpress database and edits wp-config db data and puls generated hashes in it
* Creates apache sitename.conf file in /etc/apache2/sites-available and a symlink in sites-enabled
* Adds a line to /etc/hosts file to make the domain work
* Restarts apache for the settings to take effect
* Uninstall script undoes all that leaving no trace of the install (back up your site and db before you use it)

## Future plans
* Update the stack, perhaps split installs into blueprints, for example, install enfold (with accompanying stuff), install wprig (with acompanying stuff)...COMING SOON
* Add error loging to wp-config
* Handle permissions properly following WP recomendations.

## Some comments
* This is made for myselft, for my linux boxs, on macs I use local by flywheel which is crap on linux
* Do with file what you like, though I do not take any reponsibility for it. It uses sudo in several places, so be carefull.
* I use this ONLY on local installs, and when i migrate to server I migrate data with DB Migrate, which means I do not copy any files - because of this, having permissions set like 777 is fine with me. If you plan to use it on public server, check permissions first.
* Enjoy
