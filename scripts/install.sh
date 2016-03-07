######################################################################
#                              WARNING!                              #
######################################################################
#                                                                    #
#           Replaces all existing files of the same names.           #
#   This includes things like .bashrc and .Xresources. BE PREPARED!  #
#        Make sure this script is run from the same directory        #
#          You cloned the git repo into or it will not work.         #
#                                                                    #
######################################################################

# This script is used to "install" all the parts of the setup.

fontdir=/usr/share/fonts
MANUALINS=(font-awesome* otf-hermit*)
IGNORELIST=(\\.git README.md) 

ignoregrep=""
# Creates a string used in a grep statement to retrieve only
# the files NOT in MANUALINS and IGNORELIST
for ignore in ${IGNORELIST[*]}; do
	ignoregrep=${ignoregrep}"\($ignore\)\|"
done
for ignore in ${MANUALINS[*]}; do
	ignoregrep=${ignoregrep}"\($ignore\)\|"
done
# Remove trailing "\|"
ignoregrep=$(echo $ignoregrep | sed "s/.\{2\}$//")

# Wanna copy over the fonts here
sudo cp ~/dotfilesGit/font-awesome-4.5.0/fonts/FontAwesome.otf $fontdir/OTF/
sudo cp ~/dotfilesGit/otf-hermit-1.21/Hermit-medium.otf $fontdir/OTF/

# All the files and folders we want to copy in a newline delimited list
# Get the path minus this folder (scripts)
path=$(pwd | tr '/' '\n' | head -n -1 | tr '\n' '/' | sed "s/$/\n/")
files=$(cd $path; ls -A1 | grep -v "$ignoregrep")
cd $path;

for file in $files; do
	sudo cp -Rv $file ~
done

# Make bspwm config executable
sudo chmod +x ~/.config/bspwm/bspwmrc
