FROM eclipse-temurin:21-jre-jammy

RUN apt-get update && apt-get install -y curl wget jq gnupg && \
    curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit-cloud.list && \
    apt-get update && apt-get install -y playit && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/plugins

RUN wget -O /opt/plugins/Vault.jar "https://github.com/MilkBowl/Vault/releases/download/1.7.3/Vault.jar" && \
    wget -O /opt/plugins/EssentialsX.jar "https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsX-2.20.1.jar" && \
    LP_URL=$(curl -s https://metadata.luckperms.net/data/all | jq -r '.downloads.bukkit') && \
    wget -O /opt/plugins/LuckPerms.jar "$LP_URL" && \
    ESHOP_URL=$(curl -s "https://api.modrinth.com/v2/project/economyshopgui/version" | jq -r '[.[] | select(.loaders[]=="paper" or .loaders[]=="spigot")][0].files[0].url') && \
    wget -O /opt/plugins/EconomyShopGUI.jar "$ESHOP_URL" && \
    AH_URL=$(curl -s "https://api.modrinth.com/v2/project/auctionhouse/version" | jq -r '[.[] | select(.loaders[]=="paper" or .loaders[]=="spigot")][0].files[0].url') && \
    wget -O /opt/plugins/AuctionHouse.jar "$AH_URL" && \
    CL_URL=$(curl -s "https://api.modrinth.com/v2/project/clearlagg/version" | jq -r '[.[] | select(.loaders[]=="paper" or .loaders[]=="spigot")][0].files[0].url') && \
    wget -O /opt/plugins/ClearLag.jar "$CL_URL" && \
    wget -O /opt/plugins/Geyser-Spigot.jar "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot" && \
    wget -O /opt/plugins/Floodgate-Spigot.jar "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot" && \
    VIA_URL=$(curl -s "https://api.modrinth.com/v2/project/viaversion/version" | jq -r '[.[] | select(.loaders[]=="paper" or .loaders[]=="spigot")][0].files[0].url') && \
    wget -O /opt/plugins/ViaVersion.jar "$VIA_URL" && \
    VIAB_URL=$(curl -s "https://api.modrinth.com/v2/project/viabackwards/version" | jq -r '[.[] | select(.loaders[]=="paper" or .loaders[]=="spigot")][0].files[0].url') && \
    wget -O /opt/plugins/ViaBackwards.jar "$VIAB_URL"

WORKDIR /mcserver
COPY start.sh /mcserver/start.sh
RUN chmod +x /mcserver/start.sh

EXPOSE 7860

CMD ["bash", "-c", "python3 -m http.server 7860 & /mcserver/start.sh"]
