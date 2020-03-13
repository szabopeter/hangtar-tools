#!/bin/sh

tempdir=/tmp
dt=20101231   #start date yyMMdd
st=2055     #start time hhmm
ch=1        #channel (mr#)   1-kossuth
ln=185      #length in minutes

if [ -n $1 ]
then
    dt=$1
fi

if [ -n $2 ]
then
    st=$2
fi

if [ -n $3 ]
then
    ln=$3
fi

bitrate=96
lnb=$((ln * bitrate * 7680))   #length in bytes @ bitrate kbps (bitrate*60/8*1024)

#mplayer -dumpfile 1120.mp3 -dumpaudio -endpos 200kb http://stream001.radio.hu:443/stream/20101120_130500_1.mp3
mplayer -dumpfile ${tempdir}/${dt}.mp3 -dumpaudio http://stream001.radio.hu:443/stream/${dt}_${st}00_${ch}.mp3 &
pid=${!}

fs=0
while [ $fs -lt $lnb ]
do
    sleep 10
    fs=`du -b ${tempdir}/${dt}.mp3 | sed 's/\t.*//'`
    if ps -p $pid >/dev/null
    then 
        echo "MPlayer process disappeared."
        fs=$lnb
    fi
done

while ps -p $pid >dev/null
do
    kill $pid
    sleep 1
done

mp3splt -o ${dt}.mp3 ${tempdir}/${dt}.mp3 00.00 ${ln}.00
echo "tempfile: ${tempdir}/${dt}"
echo "output: ${dt}"


