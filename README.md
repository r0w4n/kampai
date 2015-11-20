# Kampai
Kampai or Cam Pi is a bash script to caputre images from RTSP IP video streams then upload to a remote server, followed by executing a script on the remote server.
It will only caputre images during daylight hours.
## Requirements
* [sunwait](https://www.risacher.org/sunwait/)
* rsync
* avconv or ffmpeg
* Screen (remote server)

## Settings
Edit the settings.cfg file:
* *savePath* - Where to save the caputred images
* *longitude* - Longitude of where the cameras are situated
* *latitude* - Latitude of where the cameras are situated
* *remoteServer* - Remote server and user e.g. user@remote.com
* *remoteScript* - Path to remote script
* *remoteImagePath* - remote upload path
