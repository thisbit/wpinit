# wpinit
This an wordpress install script I use to automate wp setup on my machines

This script was made for linux/unix systems, not sure if works son windows
The script pressuposes local server allready setup
Owner of the project should be a member of the www-data or _www group so that by chowning wp installation it solves permission problems of the install.

Before you use this script chmod +x script.sh it

## It installs downloads latest WP
## It removes stock themes and plugins but leaves index.php files there
## It installs wprig "theme"
## It installs migrate db, classic editor and show current template
## it puts .htaccess robots and humans txt files

### I plan to add the database creation in this script as well as seting up wprig dependencies
I made this for my own use ... so use if you like ... but thats it

