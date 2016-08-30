#!/bin/sh

tempdir=/tmp
dt=101231   #start date yyMMdd
st=2055     #start time hhmm
ch=1        #channel (mr#)   1-kossuth
ln=185      #length in minutes
lnb=$((ln * 495000))   #length in bytes @ 64kbps (64*60/8*1024 = 491520) + egy kis ráhagyás

st=2124     #start time hhmm

#mplayer -dumpfile 1120.mp3 -dumpaudio -endpos 200kb http://stream001.radio.hu:443/stream/20101120_130500_1.mp3
mplayer -dumpfile ${tempdir}/${dt}.mp3 -dumpaudio http://stream001.radio.hu:443/stream/20${dt}_${st}00_${ch}.mp3 &
pid=${!}

fs=0
while [ $fs -lt $lnb ]
do
    sleep 10
    fs=`du -b ${tempdir}/${dt}.mp3 | sed 's/\t.*//'`
done

kill $pid
sleep 1
kill $pid
sleep 1
kill $pid

mp3splt -o ${dt}.mp3 ${tempdir}/${dt}.mp3 00.00 ${ln}.00
echo "tempfile: ${tempdir}/${dt}"
echo "output: ${dt}"


