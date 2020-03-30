project="jaomeni"
childthemestylesheader="/*
Theme Name: project
Author: thisbit
Template: enfold
Author URI: https://github.com/thisbit/
Description: Lorem Ipsum
Version: 1.0
Text Domain: project_
Tags: lorem, ipsum
*/
"

read -p "# CHOOSE THEME (write number): 
(1) wprig (starter theme with build processes, linting etc), 
(2) _s underscores (simple starter theme), 
(3) understrap (_s with bootstrap), 
(4) enfold (commercial theme with blockeditor, a parent theme)
: " theme

if [[ $theme = "1" ]]
	then
	wget https://github.com/wprig/wprig/archive/master.zip
	unzip master.zip
	mv wprig-master ./$project/wp-content/themes/wprig-$project
	rm -rf master.zip
elif [ $theme = "2" ]
	then
	wget https://github.com/Automattic/_s/archive/master.zip
	unzip master.zip
	mv _s-master ./$project/wp-content/themes/_s-$project
	rm -rf master.zip
	# see if you can automate string replacement "_s" with "$project"
elif [ $theme = "3" ]
	then
	wget https://github.com/understrap/understrap/archive/master.zip
	unzip master.zip
	mv understrap-master ./$project/wp-content/themes/understrap-$project
elif [ $theme = "4" ]
	then
	unzip /home/ek/serv/enfold-2020/enfold.zip -d ./$project/wp-content/themes/
	mkdir ./$project/wp-content/themes/enfold-child/
	echo "$childthemestylesheader" > ./$project/wp-content/themes/enfold-child/styles.css
	sed -i "s/project/$project/g" ./$project/wp-content/themes/enfold-child/styles.css
else
	echo "ERROR, you failed to choose an available theme!"
	exit
fi

echo "success"