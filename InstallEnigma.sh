#!/bin/bash
#ENIGMA Shell Script Installer

odir=$(pwd)
dep_1=0
dep_2=0
dep_3=0
dep_4=0
dep_5=0
dep_6=0
dep_7=0

clear
echo  "Welcome to the ENIGMA Development Environment Installer for Ubuntu."
sleep 1
echo -e "Checking if Git is installed...\n"
sleep 0.25
if ! (dpkg-query -W -f='${Status}'  git  2>/dev/null | grep -c "ok installed" ); then
	echo -e "\nGit is required to download the latest version of ENIGMA from GitHub. \nWould you like to install Git?"
	select result in "Yes" "No"
	do
	    case $result in
		"Yes")
		    sudo apt-get install git
		break
		    ;;
		"No")
		     echo "Unable to download ENIGMA without Git."
		exit
		    ;;
		*) echo invalid option;;
	    esac
	done
   else echo -e "\nGit is already installed. Proceeding."
fi
sleep 0.25
echo -e "\nChecking Dependencies...\n"
if (dpkg-query -W  -f='${Status}' g++ 2>/dev/null | grep -c "ok installed") then 
	dep_1=1
fi
if (dpkg-query -W -f='${Status}'  zlib1g-dev 2>/dev/null | grep -c "ok installed") then 
	dep_2=1
fi
if (dpkg-query -W -f='${Status}'  libglu1-mesa-dev 2>/dev/null | grep -c "ok installed") then 
	dep_3=1
fi
if (dpkg-query -W -f='${Status}'  libalure-dev 2>/dev/null | grep -c "ok installed") then 
	dep_4=1
fi
if (dpkg-query -W -f='${Status}'  libvorbisfile3 2>/dev/null | grep -c "ok installed") then 
	dep_5=1
fi
if (dpkg-query -W -f='${Status}'  libvorbis-dev 2>/dev/null | grep -c "ok installed" ) then 
	dep_6=1
fi
if (dpkg-query -W -f='${Status}'  libdumb1-dev 2>/dev/null | grep -c "ok installed") then 
	dep_7=1
fi
result=$(($dep_1+$dep_2+$dep_3+$dep_4+$dep_5+$dep_6+$dep_7 ))
sleep 0.25

if  ! [ $result -eq 7 ] ; 
	then
	echo -e "\nDependencies are not met. \nWould you like to install them?"
	select result in "Yes" "No"
	do
	    case $result in
		"Yes")
		    sudo apt-get install g++ zlib1g-dev libglu1-mesa-dev libalure-dev libvorbisfile3 libvorbis-dev libdumb1-dev
		break
		    ;;
		"No")
		     echo "Dependencies were not installed. ENIGMA can not compile."
		exit
		    ;;
		*) echo invalid option;;
	    esac
	done
   else echo -e "\nDependencies are met. Proceeding."
fi

echo -e "\nChecking if java is installed...\n"
sleep 1
if ! (  java -version ); then
	echo -e "\nJava is required to use LateralGM.\nWould you like to install OpenJDK?"
	select result in "Yes" "No"
	do
	    case $result in
		"Yes")
		    sudo apt-get install openjdk-7-jre
		break
		    ;;
		"No")
		     echo "LateralGM requires Java to run."
		exit
		    ;;
		*) echo invalid option;;
	    esac
	done
   else echo -e "\nJava is already installed. Proceeding."
fi
sleep 0.25
if [ -d $(pwd)/enigma-dev/ ]; then
	echo -e "\nenigma-dev already exists. Pulling from Git..."
	sleep 1
	cd enigma-dev
	git pull
	cd $odir
fi
if ! [ -d $(pwd)/enigma-dev/ ]; then
	echo -e "\nDownloading ENIGMA from Git to enigma-dev...\n"
	sleep 1
	git clone git://github.com/enigma-dev/enigma-dev.git
fi



echo -e "\nRunning install.py...\n"
sleep 1

cd enigma-dev
python install.py
cd $odir

/bin/cat <<EOM > ENIGMA.desktop
[Desktop Entry]
Version=1.0
Name=ENIGMA
Comment=The free open source cross-platform game development environment.
Exec= java -jar lateralgm.jar
Path=$(pwd)/enigma-dev/
Icon=$(pwd)/enigma-dev/Resources/logo.png
Terminal=true
Type=Application
Categories=Application;Development;Programming;
EOM

echo -e "\nENIGMA has been installed successfully.\n\nA desktop shortcut has been created in $(pwd)"