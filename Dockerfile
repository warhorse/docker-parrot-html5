FROM parrotsec/security:latest

ENV DEBIAN_FRONTEND=noninteractive

# COPY sources.list /etc/apt/sources.list

# RUN update-ca-certificates

RUN apt-get update && apt-get install -y apt-utils debconf-utils dialog

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt-get update
RUN apt-get install -y resolvconf

RUN apt-get update && apt-get install -y xrdp locales supervisor sudo ibus ibus-mozc dbus dbus-x11 

RUN apt-get update && apt-get -o DPkg::Options::="--force-confnew" install -y parrot-interface-common 

RUN apt-get update && apt-get -o DPkg::Options::="--force-confnew" install -y parrot-desktop-xfce

RUN locale-gen en_US && \
    apt-get update && apt-get install -y git tigervnc-standalone-server && \
    git clone https://github.com/novnc/noVNC.git /root/noVNC && \
    git clone https://github.com/novnc/websockify.git /root/noVNC/utils/websockify

RUN mkdir -p /var/run/dbus 

RUN sed -i -e 's/LogLevel=DEBUG/LogLevel=CORE/g' /etc/xrdp/xrdp.ini && \
    sed -i -e 's/SyslogLevel=DEBUG/SyslogLevel=CORE/g' /etc/xrdp/xrdp.ini && \
    sed -i -e 's/EnableSyslog=true/EnableSyslog=false/g' /etc/xrdp/xrdp.ini && \
    sed -i -e 's/LogLevel=DEBUG/LogLevel=CORE/g' /etc/xrdp/sesman.ini && \
    sed -i -e 's/SyslogLevel=DEBUG/SyslogLevel=CORE/g' /etc/xrdp/sesman.ini && \
    sed -i -e 's/EnableSyslog=true/EnableSyslog=false/g' /etc/xrdp/sesman.ini

RUN useradd -m -s /bin/bash -G sudo xuser

COPY index.html /root/noVNC/index.html
    
RUN apt-get update && apt-get install -y xfce4-taskmanager mousepad wget software-properties-common apt-transport-https

# RUN wget https://oswallpapers.com/wp-content/uploads/2020/04/default-1.jpg -O /usr/share/backgrounds/xfce/default.jpg

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg

RUN sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
RUN apt-get update && apt install code

RUN apt-get upgrade -y

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["./entrypoint.sh"]