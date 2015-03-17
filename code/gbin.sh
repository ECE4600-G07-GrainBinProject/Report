#!/bin/bash
if [ ! -f vnaJ-hl.3.1.3.jar ];
then
    echo ERROR! Missing vnaJ file...
    exit
fi

if [ -z $(lsusb | grep -e "Future Technology Devices") ];
then
    echo ERROR! MiniVNA Pro not connected...
fi

if [ $# -lt 4 ];
then
    echo ERROR! Missing parameters...
    exit
fi

if [ -z $(lsusb | grep -e "Arduino") ];
then
     echo ERROR! Arduino not connected...
else
    echo Tx: $1 - $2
    echo Rx: $3 - $4
    stty -F /dev/ttyACM0 cs8 9600 ignbrk -brkint -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts -hupcl

    for i in $(seq $1 $2)
    do
        if [ "$i" -lt 10 ];
        then
            echo sending 0$i to arduino...
            echo -n "0$i" > /dev/ttyACM0
        else
            echo sending $i to arduino...
            echo -n "$i" > /dev/ttyACM0
        fi

        echo changing transmitter to $i

        for j in $(seq $3 $4)
        do
            echo -n "$j" > /dev/ttyACM0
		 echo changing reciever to $j

            echo Running vnaJ-hl.3.1.3.jar...
            nohup java -Dconfigfile=gbin.xml -Dfstart=70000000 -Dfstop=100000000 -Dfsteps=100 -Dcalfile=gbin.cal -Dscanmode=TRAN -Dexports=csv -jar vnaJ-hl.3.1.3.jar > log.txt
            path="vnaJ.3.1/export"

		 #renaming exported file for post-processing
		 [ "$i" -lt 10 ] && tx="0$i"|| tx="$i"
            rcvr=$(expr $j - 24)
            [ "$rcvr" -lt 10 ] && rx="0$rcvr"|| rx="$rcvr"
            mv ${HOME}/$path/gbin.cal.csv /${HOME}/$path/gbin_"$tx$rx".csv
        done
    done
fi

#running post-processing process
mono put2str.exe

#delete all exported miniVNA files after post-processing is done
rm -R ${HOME}/$path/*

#upload to linked dropbox
./dropbox_uploader.sh /root/grainbin/output output
