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

    upload
    executeRemote
}

function upload() {
    /usr/bin/rsync -avzhe ssh --include '*.jpg' --exclude '*' --remove-source-files $savePath $remoteServer:"$remoteImagePath"
}

function executeRemote() {
    ssh $remoteServer screen -d -m $remoteScript
}

function capture() {
    camera=$1
    /usr/bin/avconv -i rtsp://${cameras[$camera]} -frames:v 1 -f image2 -vf scale=960:-1 -qscale:v 2 $savePath$camera-$epoch.jpg
}

function isNightTime() {
    now=`/bin/date +%s`

    if [ $now -gt $(getSunset) -o $now -lt $(getSunrise) ]; then
        return 0
    fi

    return 1
}

function getSunrise() {
    /usr/local/bin/suncal dawn
    #/usr/bin/sunwait -p $longitude $latitude | /bin/grep -Po '(?<=Sun rises )(\d+)'
    #/usr/bin/sunwait -p $longitude $latitude | /bin/grep -Po '(?<= Civil twilight starts )(\d+)'
}

function getSunset() {
    /usr/local/bin/suncal dusk
    #/usr/bin/sunwait -p $longitude $latitude | /bin/grep -Po '(?<=sets )(\d+)'
    #/usr/bin/sunwait -p $longitude $latitude | /bin/grep -Po '(?<=Civil twilight starts \d{4} UTC, ends )(\d+)'
}

main "$@"

