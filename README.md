# Eclipse : GTK3 and Ubuntu workarounds

###fix-eclipse-ubuntu-16.04-laf.sh
-------------------------------
DONT USE with Eclipse 4.5: 
Eclipse 4.5 has some issues with GTK3 in Ubuntu 16.04.  
Alternatives:
  1. Disable GTK3 with the "SWT_GTK3=0",i.e., fallback to GTK2
  2. Try Eclipse 4.6 along with this script

###fix-eclipse-ubuntu-15.10-laf.sh
-------------------------------
This script fixes the ugly tooltip in Eclipse using GTK3 when running on Ubuntu with Ambiance Theme.
It also saves a laucher script to your desktop and Ubuntu dash search. The fix is visible only if
launch using the launcher.

Usage:  
`<path>/fix-eclipse-ubuntu-15.10-laf.sh <path/to/eclipse>`

Limitations:  
Currently only works on Ubuntu 15.10 for Ambiance theme.

Please do send me pull requests if you have any update to the scripts like fixes for other Linux OSes, themes, etc.  



