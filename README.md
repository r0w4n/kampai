# Kampai
Kampai is a bash script to caputre images from an ip camera via HTTP. It then uploads it to a remote server and executes a script on that server.
It will only caputre images during daylight hours, in conjuncation with cron.
## Requirements
* [sunwait](https://www.risacher.org/sunwait/)
* rsync
* Screen (remote server)

## Settings
Edit the settings.cfg file:
* *backupPath* - Where to save the caputred images
* *longitude* - Longitude of where the cameras are situated
* *latitude* - Latitude of where the cameras are situated
* *remoteServer* - Remote server and user e.g. user@remote.com
* *remoteScript* - Path to remote script
* *remoteImagePath* - remote upload path
