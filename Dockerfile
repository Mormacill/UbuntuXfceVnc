FROM ubuntu:16.04

# XPT: x11vnc port to use
# XPW: x11vnc VNC password
# LANGUAGE: set locales
# LANGU: country code

ENV XPT=5900
ENV XPW=123456
ENV LANGUAGE=en_US.UTF-8
ENV LANGU=en

#****************************************************************************************************************#

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apt-utils && apt-get install -y locales

#timezone
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo '${LANGUAGE} UTF-8' >> /etc/locale.gen
RUN locale-gen ${LANGUAGE}
ENV DISPLAY=:0
ENV LANG=${LANGUAGE}
ENV LC_ALL=${LANGUAGE}

#install x11vnc + dummy
RUN apt-get -y upgrade && apt-get -y install xfce4 xserver-xorg-video-dummy x11vnc nano software-properties-common

#config dummy
RUN cd /usr/share/X11/xorg.conf.d/ && \
echo 'Section "Monitor"' > xorg.conf && \
echo '  Identifier "Monitor0"' >> xorg.conf && \
echo '  HorizSync 28.0-80.0' >> xorg.conf && \
echo '  VertRefresh 48.0-75.0' >> xorg.conf && \
echo '  Modeline "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync' >> xorg.conf && \
echo 'EndSection' >> xorg.conf && \
echo '' >> xorg.conf && \
echo 'Section "Device"' >> xorg.conf && \
echo '  Identifier "Card0"' >> xorg.conf && \
echo '  Driver "dummy"' >> xorg.conf && \
echo '  VideoRam 256000' >> xorg.conf && \
echo 'EndSection' >> xorg.conf && \
echo '' >> xorg.conf && \
echo 'Section "Screen"' >> xorg.conf && \
echo '  DefaultDepth 24' >> xorg.conf && \
echo '  Identifier "Screen0"' >> xorg.conf && \
echo '  Device "Card0"' >> xorg.conf && \
echo '  Monitor "Monitor0"' >> xorg.conf && \
echo '  SubSection "Display"' >> xorg.conf && \
echo '    Depth 24' >> xorg.conf && \
echo '    Modes "1920x1080_60.00"' >> xorg.conf && \
echo '  EndSubSection' >> xorg.conf && \
echo 'EndSection' >> xorg.conf

#entrypoint.sh
RUN cd /root/ && \
echo 'rm /tmp/.X0-lock' > entrypoint.sh && \
echo 'export DISPLAY=:0' >> entrypoint.sh && \
echo 'service dbus start' >> entrypoint.sh && \
echo 'X &' >> entrypoint.sh && \
echo 'sleep 3' >> entrypoint.sh && \
echo 'xauth generate :0 . trusted' >> entrypoint.sh && \
echo 'sleep 5' >> entrypoint.sh && \
echo 'startxfce4 &' >> entrypoint.sh && \
echo 'sleep 10' >> entrypoint.sh && \
echo 'x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /root/passwd.pass -rfbport ${XPT} -shared &' >> entrypoint.sh && \
chmod +x entrypoint.sh

#purge term and install needed programms
RUN apt-get -y purge gnome-terminal xterm && apt-get -y install gedit firefox sudo wget bash-completion && apt-get -y autoremove

#language support
RUN apt-get -y install language-selector-gnome && apt-get -y install $(check-language-support -l ${LANGU}) && xdg-user-dirs-update --force

RUN rm /etc/apt/apt.conf.d/docker-clean

#bash completion
RUN cd /etc/ && \
echo ''  >> bash.bashrc && \
echo '# enable bash completion in interactive shells'  >> bash.bashrc && \
echo 'if ! shopt -oq posix; then' >> bash.bashrc && \
echo '  if [ -f /usr/share/bash-completion/bash_completion ]; then' >> bash.bashrc && \
echo '    . /usr/share/bash-completion/bash_completion' >> bash.bashrc && \
echo '  elif [ -f /etc/bash_completion ]; then' >> bash.bashrc && \
echo '    . /etc/bash_completion' >> bash.bashrc && \
echo '  fi' >> bash.bashrc && \
echo 'fi' >> bash.bashrc

RUN apt-get update

#x11vnc pass-gen
RUN x11vnc -storepasswd ${XPW} /root/passwd.pass

ENV XPW=

EXPOSE ${XPT}/tcp


ENTRYPOINT  /root/entrypoint.sh & /bin/bash
