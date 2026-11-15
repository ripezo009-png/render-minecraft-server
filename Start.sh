#!/bin/bash

playit -s &

if [ ! -f /mcserver/server.jar ]; then
    curl -o /mcserver/server.jar https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/497/downloads/paper-1.20.4-497.jar
fi

mkdir -p /mcserver/plugins
cp -n /opt/plugins/*.jar /mcserver/plugins/

echo "eula=true" > /mcserver/eula.txt

if [ ! -f /mcserver/server.properties ]; then
    cat <<EOF > /mcserver/server.properties
server-port=25565
online-mode=false
max-players=30
view-distance=6
simulation-distance=4
enable-rcon=true
rcon.port=25575
rcon.password=donutadmin123
motd=DonutSMP Server 24/7 - Java & Bedrock
EOF
fi

if [ -f /mcserver/plugins/ClearLag/config.yml ]; then
    sed -i 's/autoremoval-interval: [0-9]*/autoremoval-interval: 300/g' /mcserver/plugins/ClearLag/config.yml
fi

java -Xms1G -Xmx1G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -jar /mcserver/server.jar --nogui
