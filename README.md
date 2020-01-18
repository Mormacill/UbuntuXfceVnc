# UbuntuXfceVnc-18.04
A Dockerfile for a vnc running ubuntu container with xfce


## Previous Settings
First set the Environment variables on top of the Dockerfile.
`ENV XPT=5900`

The Variable **XPT** declares the exposed port on which the vnc server shall run. The standard port is usually 5900. 

`ENV XPW=123456`

`ENV LANGUAGE=de_DE.UTF-8`



To run the built container simply type

> docker run -itd -p 5900:5900/tcp ubuntuxfce:18.04


In the words of Abraham Lincoln:

> Pardon my French
