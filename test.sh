# !/bin/bash 

if [ $1 = "xbmc" ]  || [ $1 = "all" ];then
	rm -f /home/peng/Desktop/work/seebo_eco/LE_7.0_1.0/sources/xbmc/xbmc-KOWAN2.tar.xz
	if [ $? -ne 0 ]
	then
      		notify-send "failed rm xbmc-HEX.tar.xz"
		exit
	else
	    echo 'SUCCEED rm xbmc-HEX.tar.xz'
	fi
	engrampa /home/peng/Desktop/work/seebo_eco/LE_7.0_1.0/sources/xbmc/xbmc-KOWAN2 -a /home/peng/Desktop/work/seebo_eco/LE_7.0_1.0/sources/xbmc/xbmc-KOWAN2.tar.xz

  if [ $? -ne 0 ]
	then
		notify-send "failed rm xbmc-HEX.tar.xz"
		exit
	else
	    echo 'SUCCEED engrampa tar.xz xbmc-HEX'
	fi 

	PROJECT=KOWAN2 ARCH=aarch64 ./scripts/clean xbmc
	if [ $? -ne 0 ]
	then
		notify-send "failed rm xbmc-HEX"
		exit
	else
	    echo 'SUCCEED rm xbmc-HEX'
	fi 

fi 



if [ $1 = "service" ] || [ $1 = "all" ]; then
	rm -f /home/peng/Desktop/work/seebo_eco/LE_7.0_1.0/sources/service.openelec.settings/service.openelec.settings-KOWAN2.zip
	if [ $? -ne 0 ]
	then
		notify-send "failed rm service.zip"
		exit
	else
	    echo 'SUCCEED rm service.zip'
	fi

	engrampa /home/peng/Desktop/work/seebo_eco/LE_7.0_1.0/sources/service.openelec.settings/service.openelec.settings-KOWAN2 -a /home/peng/Desktop/work/seebo_eco/LE_7.0_1.0/sources/service.openelec.settings/service.openelec.settings-KOWAN2.zip
	if [ $? -ne 0 ]
	then
	    notify-send "failed engrampa tar.xz Service-openelec-settings"
		exit
	else
	    echo 'SUCCEED engrampa tar.xz Service-openelec-settings'
	fi 

	PROJECT=KOWAN2 ARCH=aarch64 ./scripts/clean service.openelec.settings-KOWAN2
	if [ $? -ne 0 ]
	then
	    notify-send "failed rm Service-openelec-settings"
		exit
	else
	    echo 'SUCCEED rm Service-openelec-settings'
	fi 

fi


PROJECT=KOWAN2 ARCH=aarch64 make amlpkg
if [ $? -ne 0 ]
then
    notify-send "failed make hex"
	exit
else
    echo 'SUCCEED hex folder'
fi



rm -f /media/peng/D4F9-7981/Kowan2/update.zip
if [ $? -ne 0 ]
then
    notify-send "failed delet usb zip"
	exit
else
    echo 'SUCCEED delet usb zip'
fi


cp -rf /home/peng/Desktop/work/seebo_eco/LE_7.0_1.0/target/KOWAN2-2.0.1.rc1/update.zip /media/peng/D4F9-7981/Kowan2/
if [ $? -ne 0 ]
then
    notify-send "failed cp to usb"
	exit
else
    echo 'SUCCEED cp to usb'
fi
notify-send "KOWAN2 Successful. READY COMPILE"



echo "DONE ~~~~~~~~~~~~~"
