#! /bin/bash

MythicPath=/opt/docker/Mythic
Scripts=/opt/docker/Mythic_changes

# Install Mythic
cd /opt/docker
$MythicPath/stop_mythic.sh
rm -rf $MythicPath
git clone https://github.com/its-a-feature/Mythic
cp $Scripts/config.json $MythicPath/mythic-docker/
$MythicPath/start_mythic.sh

# Install Apollo
cd $MythicPath
$MythicPath/install_agent_from_github.sh https://github.com/MythicAgents/Apollo
cp $Scripts/Apollo.csproj $MythicPath/Payload_Types/Apollo/agent_code/Apollo/
cp $Scripts/AssemblyInfo.cs $MythicPath/Payload_Types/Apollo/agent_code/Apollo/Properties/
rm -rf $MythicPath/Payload_Types/Apollo/agent_code/ApolloIcoJPEG.ico $MythicPath/Payload_Types/Apollo/agent_code/Apollo/ApolloIcoJPEG.icoi

$MythicPath/start_mythic.sh
