#!/bin/bash
set -e

CUR_DIR=`pwd`
CONF_DIR="/etc/vite"
BIN_DIR="/usr/local/vite"
LOG_DIR=$HOME/.gvite
BASH_DIR=$HOME
BASH_ALIASES=$BASH_DIR"/.bash_aliases"
NODE_CONFIG=$HOME"/node_config.json"

install_vite() {
echo "install executable file to "$BIN_DIR
sudo mkdir -p $BIN_DIR
mkdir -p $LOG_DIR
sudo cp $CUR_DIR/gvite $BIN_DIR

echo '#!/bin/bash
exec '$BIN_DIR/gvite' -pprof -config '$CONF_DIR/node_config.json' >> '$LOG_DIR/std.log' 2>&1' | sudo tee $BIN_DIR/gvited > /dev/null

sudo chmod +x $BIN_DIR/gvited

ls  $BIN_DIR/gvite
ls  $BIN_DIR/gvited

echo "config vite systemd service with automatic start on boot."

echo '[Unit]
Description=GVite node service
After=network.target

[Service]
ExecStart='$BIN_DIR/gvited'
Restart=on-failure
User='`whoami`'
LimitCORE=infinity
LimitNOFILE=10240
LimitNPROC=10240

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/vite.service>/dev/null

sudo systemctl daemon-reload
}


if [ -f $NODE_CONFIG ]; then
echo "node_config.json already exists."
else
echo "Cannot find existing node_config.json so it will be generated."
echo "What is your node name/identity?"
read NODE_NAME
echo "What is your vite wallet address you want to receive staking rewards to?"
read REWARD_ADDRESS

echo "Creating node_config.json for node "$NODE_NAME" and set reward address to "$REWARD_ADDRESS". You can edit these also later on using command micro "$HOME"/node_config.json"

echo '{
"Identity": "'$NODE_NAME'",
"NetID": 1,
"ListenInterface": "0.0.0.0",
"Port": 8493,
"FilePort": 8494,
"MaxPeers": 10,
"MinPeers": 5,
"MaxInboundRatio": 2,
"MaxPendingPeers": 5,
"BootSeeds": [
"https://bootnodes.vite.net/bootmainnet.json"
],
"Discover": true,
"RPCEnabled": true,
"HttpHost": "0.0.0.0",
"HttpPort": 48132,
"WSEnabled": false,
"WSHost": "0.0.0.0",
"WSPort": 41420,
"HttpVirtualHosts": [],
"IPCEnabled": true,
"PublicModules": [
"ledger",
"net",
"contract",
"util",
"debug",
"sbpstats",
"dashboard"
],
"Miner": false,
"CoinBase": "",
"EntropyStorePath": "",
"EntropyStorePassword": "",
"LogLevel": "info",
"DashboardTargetURL": "wss://stats.vite.net",
"RewardAddr": "'$REWARD_ADDRESS'"
}' | sudo tee ~/node_config.json>/dev/null
fi
# add node_config to path
sudo mkdir -p $CONF_DIR
sudo cp $HOME/node_config.json $CONF_DIR
ls  $CONF_DIR/node_config.json


# TODO: create bash CLI instead of using aliases
if [ -f $BASH_ALIASES ]; then
echo "bash_aliases already created"
else
echo "install bash aliases to "$BASH_ALIASES
echo "alias vite=\"/usr/local/vite/gvite attach ~/.gvite/maindata/gvite.ipc\"
alias start=\"sudo service vite start\"
alias stop=\"sudo service vite stop\"
alias kill=\"pgrep gvite | xargs kill -s 9\"
alias check=\"ps -ef | grep gvite\"
alias logs=\"tail -100f ~/.gvite/std.log\"
alias download=\"curl -s https://api.github.com/repos/vitelabs/go-vite/releases/assets/34911703 | jq -r \".browser_download_url\" | xargs sudo curl -L -o ~/gvite_latest.tar.gz \"
alias updatetar=\"tar -xf ~/gvite_latest.tar.gz -C ~/ --wildcards gvite*linux/gvite --strip-components=1 && sudo rm -rf ~/gvite_latest.tar.gz\ && . ./viteinstall.sh && vite_install \"
alias restart=\"sudo service vite restart\"
alias update=\"download && stop && updatetar && start && logs\"" | sudo tee $BASH_ALIASES>/dev/null & source $BASH_DIR/.bashrc

echo "install config to "$CONF_DIR
fi

if [ -f $LOG_DIR/gvite ]; then
echo "Vite already downloaded for installing. You can update it with update command."
else
echo "Lets download and install latest vite for installation."
curl -s https://api.github.com/repos/vitelabs/go-vite/releases/assets/34911703 | jq -r .browser_download_url | xargs sudo curl -L -o ~/gvite_latest.tar.gz && sudo systemctl stop vite.service | tar -xf ~/gvite_latest.tar.gz -C ~/ --wildcards gvite*linux/gvite --strip-components=1 && sudo rm -rf ~/gvite_latest.tar.gz &&  install_vite && sudo systemctl start vite.service
fi
