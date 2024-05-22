FROM azul/zulu-openjdk:17

MAINTAINER LightSwitch <lightswitch2024@gmail.com> 

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN apt-get update && \
apt-get install -y wget gnupg && \
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /usr/share/keyrings/postgresql.gpg > /dev/null && \
. /etc/os-release && \
echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list


RUN apt-get update && \
apt-get install -y sudo && \
apt-get install -y postgresql-16 && \
apt-get install -y nginx && \
apt-get install -y git

RUN apt-get install -y curl && \
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - && \
apt-get install -y nodejs

RUN npm install -g npm && \
npm install -g yarn && \
apt-get install -y vim

COPY ./database-setup.sql /home/conf/database-setup.sql
COPY ./install.sh /home/conf/install.sh
COPY ./default.conf /etc/nginx/sites-enabled/default

#COPY ./frontend/dist/* /var/www/html/test

RUN sed -i 's/\r$//'  /home/conf/install.sh

ENTRYPOINT [ "/bin/bash", "/home/conf/install.sh" ]
