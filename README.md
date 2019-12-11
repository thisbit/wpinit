# wpinit
This is a wordpress install script I use to automate wp setup on my machines

* This script was made for linux/unix systems, not sure if works on windows
* The script presuposes local server allready setup
* Owner of the project should be a member of the www-data or _www group so that by chowning wp installation it solves permission problems of the install.
* Before you use this script, make it executable by running "chmod +x wpinit.sh" 

## It downloads latest WP
## It removes stock themes and plugins but leaves index.php files in themes and plugins folder
## It installs wprig "theme"
## It installs migrate db, classic editor and show current template which I alsways install
## it puts htaccess, robots and humans files in wordpress root

### I plan to add the database creation in this script as well as seting up wprig dependencies automatically
* I made this for my own use ... so use if you like ... but thats it
* I use zsh if you use bash, change first line accordingly
* Run as sudo if your sever root is outside of your home folder
* On location promt enter dot if you want to install in current directory
