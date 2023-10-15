# WpInit
### This repo is for personal use, use with caution

## Contents
* Wordpress installer based on WP-CLI ( wpclinit.sh )
* Wordpress installer only shell based ( wpinit.sh ) - deprecated
* Wordpress uninstaller only shell based ( wprm.sh )
* Wordpress plugins installer based on WP-CLI ( wpcliplugins.sh ) - deprecated

## Depends
* Linux or Mac (tested with debian, for mac some modifications needed)
* LAMP installed
* WPCLI installed
* Wordpress packages are in some cases premium producst so you need to have these for these options of the script to work

## What does it do?
* Sets up a local domain like projectname.domain
* Installs wordpress and database
* Removes all defaults content in wp install, unless you select "wp defaults" option 
* Installs a set of themes and acompanied plugins, or builder and acompenied tools
* Optionally installs a plugin bundle of your choice
* WpRm removes the entire thing, files and database entry

## Some comments
* wpinit is the older file, I am keeping it for archive mostly, same with wpcliplugins
* Please read the script before running, it is simple, there are comments, it uses "sudo", dont brake your system
* I recomend you to create alias to more easily use
* Enter your web root when running the install script
* Do not use this on your server, in the line 176 permission of the entire WordPress installation is made writeable for all. This is ok on the local machine, but in no way ok on the server.

### Enjoy!