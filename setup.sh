#!/bin/bash
echo "Installing tboplayer and its dependencies..."

echo "* Updating distro packages database... This may take some seconds."
#sudo apt-get update >/dev/null 2>&1
command -v omxplayer >/dev/null 2>&1
if [ $? -eq 1 ]; then 
    echo "* Installing omxplayer..."
    sudo apt-get install omxplayer >/dev/null 2>&1
else
    echo "* Updating omxplayer..."
    sudo apt-get upgrade >/dev/null 2>&1
fi

# install pexpect it's if not installed
python -c 'import pexpect' >/dev/null 2>&1
if [ $? -eq 1 ]; then 
    echo "* Installing pexpect..."
    wget -P ~ http://pexpect.sourceforge.net/pexpect-2.3.tar.gz >/dev/null 2>&1
    tar xzf ~/pexpect-2.3.tar.gz #>/dev/null
    cd ~/pexpect-2.3
    sudo python ./setup.py install >/dev/null 2>&1
    cd ..
fi

# install youtube-dl it's if not installed
command -v youtube-dl >/dev/null 2>&1
if [ $? -eq 1 ]; then 
    echo "* Installing youtube-dl..."
    sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl >/dev/null 2>&1
    sudo chmod a+rx /usr/local/bin/youtube-dl 
else 
    echo "* Updating youtube-dl..."
    sudo youtube-dl -U >/dev/null 2>&1
fi

cd ~/bin >/dev/null 2>&1
if [ $? -eq 1 ]; then
    mkdir ~/bin
fi

# install tboplayer 'shortcut' in /home/<user>/bin
echo "* Installing tboplayer..."
FAKE_BIN=~/bin/tboplayer
cd $FAKE_BIN >dev/null 2>&1
if [ $? -eq 1 ]; then 
    mv ~/KenT2-tboplayer-* ~/tboplayer
    echo '#!/bin/bash' >> $FAKE_BIN
    echo 'python ~/tboplayer/tboplayer.py' >> $FAKE_BIN
    chmod +x $FAKE_BIN
fi

DESKTOP_ENTRY=~/Desktop/tboplayer.desktop
$DESKTOP_ENTRY >/dev/null 2>&1
if [ $? -eq 127 ]; then 
    echo '[Desktop Entry]' >> $DESKTOP_ENTRY
    echo 'Name=TBOPlayer' >> $DESKTOP_ENTRY
    echo 'Comment=UI for omxplayer' >> $DESKTOP_ENTRY
    echo 'Exec=python '$HOME'/tboplayer/tboplayer.py "%F"' >> $DESKTOP_ENTRY
    echo 'Icon=/usr/share/pixmaps/python.xpm' >> $DESKTOP_ENTRY
    echo 'Terminal=false' >> $DESKTOP_ENTRY
    echo 'Type=Application' >> $DESKTOP_ENTRY
fi

echo "* Installation finished."
echo "*"
echo "* If all went as expected, TBOPlayer is now installed on your system." 
echo "* To run it, just type 'tboplayer', or use the icon created in your Desktop."
echo " Good bye. ;)"

exit;
