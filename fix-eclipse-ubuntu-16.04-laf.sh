#/bin/bash
# This programs fixes the ugly tooltip in Eclipse using GTK3 
# running on Ubuntu with Ambiance Theme.
#
# Copyright (C) 2016 Kiran Mohan
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>
#

# TODO: fix for Radiance theme

OS_NAME="Ubuntu"
OS_VERSION="16.04"
OS_FULLNAME="$OS_NAME $OS_VERSION"

# tested only ubuntu for now
lsb_release -a 2>&1 |grep -q "$OS_FULLNAME"
if [ $? -ne 0 ]; then
	echo "This scripts is only tested on $OS_FULLNAME."
	echo "Bye"
	exit 0;
fi

# check arguments
if [ $# -eq 0 ]; then 
	echo "Usage: $0  <path/to/eclipse>"
	exit 0;
fi


# check ECLIPSE_HOME is valid or not
ECLIPSE_HOME=`readlink -m $1`
if [ -f $ECLIPSE_HOME ]; then
	ECLIPSE_HOME=`dirname $ECLIPSE_HOME`
fi
if [ ! -f $ECLIPSE_HOME/eclipse ]; then
	echo "Eclipse not found in $ECLIPSE_HOME"
	exit 0;
fi
ECLIPSE_VERS=`grep version $ECLIPSE_HOME/.eclipseproduct | sed 's/version=//'`
DATE=`date|tr ' ' '_'`

# Fetch location of desktop directory
DESKTOP_DIR=$(xdg-user-dir DESKTOP)

# Directory where the modified Ambiance-Eclipse theme is stored.
ECLIPSE_THEME_ROOT_DIR=$HOME/.eclipse/share/themes
ECLIPSE_THEME_DIR=$ECLIPSE_THEME_ROOT_DIR/Ambiance-Eclipse
if [ -d $ECLIPSE_THEME_DIR ];then
	mv $ECLIPSE_THEME_DIR $ECLIPSE_THEME_DIR".b4_"$DATE
fi
mkdir -p $ECLIPSE_THEME_DIR

# copy Ambiance-Eclipse theme and modify tooltip color
cp -rf /usr/share/themes/Ambiance/* $ECLIPSE_THEME_DIR
sed -i 's/Ambiance/Ambiance-Eclipse/g' \
	    $ECLIPSE_THEME_DIR/index.theme  \
	    $ECLIPSE_THEME_DIR/metacity-1/metacity-theme-1.xml

sed -i -r -e 's/@define-color tooltip_bg_color.*/@define-color tooltip_bg_color #f5f5c5;/'\
	  -e 's/@define-color tooltip_fg_color.*/@define-color tooltip_fg_color #000000;/'\
		$ECLIPSE_THEME_DIR/gtk-3.0/gtk-main.css

# also copy Default theme (somehow needed to keep button border
# animations the same)
cp -rf /usr/share/themes/Default $ECLIPSE_THEME_DIR/../

# create Eclipse launch menu
LAUNCH_FILENAME="eclipse_$ECLIPSE_VERS.desktop"
if [ -f $DESKTOP_DIR/$LAUNCH_FILENAME ]; then
	mv $DESKTOP_DIR/$LAUNCH_FILENAME $DESKTOP_DIR/$LAUNCH_FILENAME.b4_$DATE
fi
touch $DESKTOP_DIR/$LAUNCH_FILENAME

cat > $DESKTOP_DIR/$LAUNCH_FILENAME << endtext
[Desktop Entry]
Version=$ECLIPSE_VERS
Name=Eclipse $ECLIPSE_VERS
Comment=Eclipse IDE $ECLIPSE_VERS
Exec=env GTK_DATA_PREFIX=$HOME/.eclipse GTK_THEME=Ambiance-Eclipse $ECLIPSE_HOME/eclipse
Icon=$ECLIPSE_HOME/icon.xpm
Terminal=false
Type=Application
Categories=Utility;Application;
endtext

# Add the launch menu $HOME/.local/share/applications
if [ -f $HOME/.local/share/applications/$LAUNCH_FILENAME ]; then
	mv $HOME/.local/share/applications/$LAUNCH_FILENAME $HOME/.local/share/applications/$LAUNCH_FILENAME.b4_$DATE
fi
cp $DESKTOP_DIR/$LAUNCH_FILENAME $HOME/.local/share/applications/$LAUNCH_FILENAME

# set the permission to launch files
chmod 700 $DESKTOP_DIR/$LAUNCH_FILENAME $HOME/.local/share/applications/$LAUNCH_FILENAME


# say bye
echo "Completed fixing Eclipse UI for $OS_FULLNAME"
echo "You can launch Eclipse from launcher on the Desktop or by search for Eclipse in Unity Dash"
echo "Bye"

# END OF SCRIPT

