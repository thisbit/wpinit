read -p "# CHOOSE THEME (write number): 
(1) wprig, 
(2) understrap, 
(3) underscores, 
(4) enfold
: " theme

if [[ $theme = "1" ]]
	then
	wget https://github.com/wprig/wprig/archive/master.zip
elif [[ $theme = "2" ]]
	then
	wget https://github.com/Automattic/_s/archive/master.zip
elif [[ $theme = "3" ]]
	then
	wget https://github.com/understrap/understrap/archive/master.zip
else
	echo "You choose wrong"
	exit
fi

echo "success"