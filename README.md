# wpinit
## THIS REPO IS FOR PERSOAL USE. USE IT WITH CAUSION BECAUSE IT CAN BRAKE YOUR SYSTEM.

## Contents
* Wordpress installer based on WP-CLI ( wpclinit.sh )
* Wordpress installer only shell based ( wpinit.sh )
* Wordpress uninstaller only shell based ( wprm.sh )
* Wordpress plugins installer based on WP-CLI ( wpcliplugins.sh )

## Depends
* Linux (works on debianites, and should work with not much modifications on other linuxes/macs too)
* Admin privileges
* MySql server has to be set up prior, and user with root db privileges should be same as your linux/mac admin user
* Apache2 shoudl also be set up prior
* WP-CLI should be installer prior
* Some installs work with locally stored premium themes and plugins ( enfols, generatepress, oxygenbuilder )
* Internet access

## What does it do?
* Sets up local server with custom domain
* Installs Wordpress and links it to database
* If chosen, removes all default content from wordpress, themes, plugins, posts and pages
* Installs chosen theme, its child theme if applicable and activates it
* Installes chosen plugin bundle, and in some cases activates it
* Uninstalls the entire thing, the files, database and server settings

## Some comments
* wpinit is the older file, I am keeping it for archive mostly
* read the script before running, it simple, there are comments, dont brake your system
* its recomended to create alias to more easily use
* enter your web root when running the install script

### Enjoy!