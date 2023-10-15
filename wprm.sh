### destroy a wordpress installation and all traces thereof
echo "THIS IS THE WORDPRESS UNINSTALLER"
# get variables
		echo  "# WARNING: run this in your webroot!"
	# the project title
		read -p "# ENTER THE PROJECT TITLE: " project
	# the project owner (member of groups _www on mac or www-data on linux)
		read -p "# USER (local sudo user): " owner
	# the db password
		read -p "# PASSWORD: " pass

# delete wordpress directory
rm -rf ./$project

# delete mysql database
sudo mysql -u$owner -p$pass -e "DROP DATABASE $project"

# delete apache conf file
sudo rm /etc/apache2/sites-available/$project.stroj.conf

# delete apache2 symlink
sudo rm /etc/apache2/sites-enabled/$project.stroj.conf

# remove redirect from hosts file
sudo -- sh -c "sed -i s/127\.0\.1\.1.*$project\.stroj// /etc/hosts"

# restart apache
sudo apachectl -k graceful
