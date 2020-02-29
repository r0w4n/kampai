#!/bin/bash

main() {
    source settings.cfg
    epoch=`/bin/date +%s`

    if isNightTime ; then
        echo "sunrise:$(getSunrise) sunset:$(getSunset)  exiting..."
        exit
    fi

    for camera in "${!cameras[@]}"
    do
        capture $camera
    done

    backup
    upload
    executeRemote
}

function backup() {
    cp $savePath*.jpg $backupPath 
}

function upload() {
    /usr/bin/rsync -avzhe ssh --include '*.jpg' --exclude '*' --remove-source-files $savePath $remoteServer:"$remoteImagePath"
}

function executeRemote() {
    ssh $remoteServer screen -d -m $remoteScript
}

function capture() {
    camera=$1
    /usr/bin/ffmpeg -i rtsp://${cameras[$camera]} -vframes 1 -f image2 -vf scale=-1:1080 $savePath$camera-$epoch.jpg
}

function isNightTime() {
    now=`/bin/date +%s`

    if [ $now -gt $(getSunset) -o $now -lt $(getSunrise) ]; then
        return 0
    fi

    return 1
}

function getSunrise() {
    date --date='TZ="Europe/London" 08:00' +%s
}

function getSunset() {
    /usr/local/bin/suncal dusk
}

main "$@"
