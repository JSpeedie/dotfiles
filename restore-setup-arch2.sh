######################################################################
#                              WARNING!                              #
######################################################################
#                                                                    #
#           Replaces all existing files of the same names.           #
#  This includes thins like .bashrc, .Xresources, etc. BE PREPARED!  #
#                                                                    #
######################################################################

# This script is used to "install" all the parts of the setup.

fontdir=/usr/share/fonts

# Wanna copy over the fonts here
sudo cp font-awesome-*/fonts/*.otf $fontdir/fonts/OTF/FontAwesome.otf
sudo cp otf-hermit-*/*.otf $fontdir/fonts/OTF/Hermit-medium.otf

# Copy all my dotfiles to their location. Some need to be done
# manually because of them not being located in the home directory
sudo cp -R * ~
# Remove files that will be separately "installed" or are part
# of the repo, but don't need to be in your home folder
# (like README.md, font-awesome, otf-hermit, .git and LICENSE)

# Make bspwm config executable
sudo chmod +x ~/.config/bspwm/bspwmrc
