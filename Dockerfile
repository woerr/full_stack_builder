FROM ubuntu:18.04
RUN apt-get update && apt-get install -y curl wget && apt-get install -y tzdata && apt install software-properties-common -y && add-apt-repository ppa:ondrej/php

RUN && apt-get install -y sshpass && apt-get install -y nodejs git yarn && mkdir /weldbook && mkdir /weldbook/dist && mkdir /weldbook/src && mkdir /weldbook/ssh && mkdir /weldbook/sh && mkdir /root/.ssh/ 

RUN  apt install php7.3 php7.3-common php7.3-mysql php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-mbstring php7.3-zip php7.3-intl rsync php-sockets composer  -y

RUN set -xe;

RUN mkdir -p /root/.ssh
WORKDIR /weldbook
CMD ["/bin/bash", "-c"]
