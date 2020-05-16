# UbuntuXfceVnc
A Dockerfile for a vnc running ubuntu container with xfce


## Previous Settings
First you´re able to change the ubuntu distribution. Do that by editing the Version number in the first line:

`FROM ubuntu:20.04`

the Dockerfile is tested with 18.04 and 20.04. <br><br>

Then set the Environment variables on top of the Dockerfile.

`ENV XPT=5900`

The variable **XPT** declares the exposed port on which the vnc server shall run. The standard port is usually 5900. 

`ENV XPW=123456`

The variable **XPW** declares the password you would like to use for your vnc access. You are free to choose it.

`ENV LANGUAGE=en_US.UTF-8`

The variable **LANGUAGE** declares the language locale for your country or the language you would like to use the Xfce-Desktop.

**Tested with:**

`en_US.UTF-8`

`de_DE.UTF-8`

`fr_FR.UTF-8`

Since version updates of Ubuntu 18.04 somehow languages doesn´t work consistently anymore, just partial. In former versions it worked with full translation. It´s your choice to use the Desktop with full-english or partial translated.

## Build the Container

To build the Dockerfile just go to the directory containing the Dockerfile and run

> docker build -t {YourImageName:release} . 

## Run the container

To run the built container simply type

> docker run -itd -p 5900:5900/tcp --name {ContainerName} {YourImageName:release}

If necessary adjust the published port if you changed the environment variable in the Dockerfile.
After that give the container about 20 seconds to start up the desktop and the vnc server.

Now you can join the Xfce-Desktop via a common vnc client.
