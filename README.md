![viteinstall_logo](https://user-images.githubusercontent.com/15621959/151674771-fa4f647c-91cf-435c-9149-6db95c4e20ef.png)
# viteinstall

## Pre-Installation
Create a new user for gvite with sudo rights and run following command on after logging in the user.
```
adduser gvite
passwd gvite
sudo usermod -aG sudo gvite  #debian/ubuntu
sudo usermod -aG wheel gvite  #centos/rocky
su gvite && cd ~
sudo apt update && sudo apt install curl git jq tar  #debian/ubuntu
sudo apt update && sudo yum install curl git jq tar  #centos/rocky 
```

## Installation
Then commit following line to install latest vite client and get your node running.
```
git clone https://github.com/hitchhooker/viteinstall ~/ && sudo chmod +x ~/viteinstall/viteinstall.sh && .~/viteinstall/viteinstall.sh
```

## Usage
Script creates simple bash_aliases to make controlling your node effortless:
### Commands
```
check	checks current vite processes to avoid duplication  
kill	kills current vite processes  
start	starts node  
stop	stops node  
restart	restart node  
enable	enables node to start automatically on startup  
disable	disables node to start automatically on startup  
vite	connects you to vite command line to communicate directly  
	with node for more info  
logs  	prints 100 last logs and begans following logging in realtime  
update	updates latest vite client from github
```
  
## Tip me
If you find this installation script useful, please TIP me for opensourcing script :-)  
  
vite_4ea24667f4f5a8026e111eb4ad2ad3d3bfdc5ab5a74d4e7209
