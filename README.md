# wpinit
This repo contains a wordpress install and uninstall scripts that I use daily on my Linux box. It can works with OSX too with slight modifications, but there I find it makes more sense to use http://vagrantup.com with http://vccw.cc instead of this
If it isn't obvious from file names, riginit.sh is the installer and rigrm.sh is the uninstaller, while choice.sh is a code for choosing themes I plan to include in the next version of the install script. I plan to simplify and extend the functionality of the files in repo as I find time and learn more.

## Dependencies & Requirements
* Script was made on Debian 10 (systemd) and it uses common applications one can find on most *nix systems. Wget, Sed, Grep, Unzip etc, I avoided git, systemd specifics etc as much as I am aware to make it Linux portable.
* Script assumes Apache, MySql and PhP already set up.
* Script assumes your linux user has sudo priviledges and that the same name mysql user (with same pswd) also has admin priviledges to create, edit and delete databases.
* At the end of the script, virtual hosts and virtual domains are setup, so you have to have that set up on your machine to work as well. My machine has "stroj" domain, so websites get domain.stroj URLS.
* Make sure to chown /etc/apache2/sites-available and /etc/apache2/sites-enabled folders so that you can create files in there.
* For now, script installs http://wprig.io theme, read about it to learn more what requirements it has.
* If you use an editor other the VS code, Sublime or Atom, edit the last line to change that, also if you haven't allready make symlinks to the editors.

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
* I plan to add interactive options to the script so one can choose from few themes that I like, which one to install.
* I plan to add theme dependencies install (npm modules, composer modules etc)

## Some comments
* Since I use linux as a workstation, it makes no sense to me to download another linux with each new website, run vbox etc vith tools like http://vagrantup.com
* I am sharing this in case someone finds it useful, but I take no responsibility for any damage you may produce while you use it. Script uses sudo and can therefore potentialy do damage to your system.
* I intend to comment all the code so as to make it more clear, allthough its pretty simple without it too.
* You can change it, improve it, brake it ... do what you like, just don't ask for help or advice its just a tool I made for my self.
* Enjoy
