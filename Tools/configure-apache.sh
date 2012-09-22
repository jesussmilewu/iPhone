#!/bin/sh

userDir=.
configFile=$userDir/$USER.conf
content="<Directoy \"/Users/$USER/Sites/\">\nOptions Indexes MultiViews\nAllowOverride All\nOrder allow,deny\nAllow from all\n</Directory>"
if [ -f $configFile ]
then
	echo "Config file $configFile already exists."
else
	echo "Create config file $configFile."
	echo $content > $configFile
fi
