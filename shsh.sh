#!/bin/sh

echo "#Issue SHSH checker Ver.2.0"
release=$(curl -s "https://api.ipsw.me/v4/device/`echo $1`?type=ipsw" | jq ".firmwares[] | select(.signed == "true")" 2>/dev/null)
beta=$(curl -s "https://api.m1sta.xyz/betas/`echo $1`" | jq ".[] | select(.signed == "true")" 2>/dev/null)
STR3="$beta$release"
#jqコマンドを確認します
which jq >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  if [ "$(uname)" == 'Darwin' ]; then
    #MacOS
    which brew >/dev/null 2>&1
    if [ $? -ne 0 ] ; then
      #存在しない場合はインストールするようメッセージを出力して実行を停止します
      echo "E:brew command not installed"
      echo "Enter the following command to install"
      echo " bash <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      exit 1
    else
      #Homebrewがあればlibzipをインストールします
      brew install jq
    fi
  elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    #Ubuntuの場合
    sudo apt update
    sudo apt install jq
  fi
fi

#引数が1つの場合
if [ $# = 1 ]; then
  echo $STR3 | jq -r '. | .result = (.buildid|tostring) + " " + .version | .result' 2>/dev/null | sed "s/^/  /g"
  echo $(echo $STR3 | jq -r '. | .result = (.buildid|tostring) + " " + .version | .result' 2>/dev/null | wc -l) shsh available
  exit
fi

#pzbコマンドを確認します
which pzb >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  if [ "$(uname)" == 'Darwin' ]; then
    #MacOS
    which brew >/dev/null 2>&1
    if [ $? -ne 0 ] ; then
      #存在しない場合はインストールするようメッセージを出力して実行を停止します
      echo "E:brew command not installed"
      echo "Enter the following command to install"
      echo " bash <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      exit 1
    else
      #Homebrewがあればlibzipをインストールします
      brew install libzip
    fi
    curl -OL https://github.com/tihmstar/partialZipBrowser/releases/download/36/buildroot_macos-latest.zip
    unzip buildroot_macos-latest.zip buildroot_macos-latest/usr/local/bin/pzb
    rm -f buildroot_macos-latest.zip
    mkdir ~/Applications/pzb
    cp buildroot_macos-latest/usr/local/bin/pzb ~/Applications/pzb/
    chmod -R 766 ~/Applications/pzb/
    rm -rf buildroot_macos-latest
    export PATH="$PATH:~/Applications/pzb/"
    touch ~/.zshrc && echo export PATH="$PATH:~/Applications/pzb/" >> .zshrc
    touch ~/.bashrc && echo export PATH="$PATH:~/Applications/pzb/" >> .bashrc
    source ~/.zshrc
  elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    #Ubuntuの場合
    which curl > /dev/null 2>&1 && which unzip > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
      sudo apt update
      sudo apt install curl unzip jq
    fi
    curl -OL https://github.com/tihmstar/partialZipBrowser/releases/download/36/buildroot_ubuntu-latest.zip
    unzip buildroot_ubuntu-latest.zip buildroot_ubuntu-latest/usr/local/bin/pzb
    rm -f buildroot_ubuntu-latest.zip
    sudo cp buildroot_ubuntu-latest/usr/local/bin/pzb /usr/bin/
    sudo chmod -R 777 /usr/bin/pzb
    rm -rf buildroot_ubuntu-latest
  fi
fi

#tsscheckerコマンドを確認します
which tsschecker >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  if [ "$(uname)" == 'Darwin' ]; then
    #MacOS
    curl -OL https://dl.dropboxusercontent.com/s/waggu1mk4u42zn0/tsschecker    
    mkdir ~/Applications/tsschecker
    cp tsschecker ~/Applications/tsschecker/
    chmod -R 766 ~/Applications/tsschecker
    rm -f tsschecker
    export PATH="$PATH:~/Applications/tsschecker/"
    touch ~/.zshrc && echo export PATH="$PATH:~/Applications/tsschecker/" >> .zshrc
    touch ~/.bashrc && echo export PATH="$PATH:~/Applications/tsschecker/" >> .bashrc
    source ~/.zshrc
  elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    #Ubuntuの場合
    echo "E:tsschecker command not installed"
    exit 1
  fi
fi

#引数が2つの場合
if [ $# = 2 ]; then
  if [ -d $1 ]; then
    cd $1
  else
    mkdir $1
    cd $1
  fi
  if [ -d $2 ]; then
    cd $2
  else
    mkdir $2
    cd $2
  fi
  numbershsh=0
  while [ $numbershsh != $(echo $STR3 | jq -r '.url' 2>/dev/null | wc -l) ]
  do
    numbershsh=$(( $numbershsh+1 ))
    pzb -g BuildManifest.plist $(echo $STR3 | jq -r '.url' 2>/dev/null | sed -n `echo $numbershsh`P)
    tsschecker -d $1 -e $2 -m BuildManifest.plist --generator 0x1111111111111111 -s
    mv BuildManifest.plist ../$(echo $STR3 | jq -r '.buildid' 2>/dev/null | sed -n `echo $numbershsh`P).plist
    rm -f BuildManifest.plist
  done
  echo $STR3 | jq -r '. | .result = (.buildid|tostring) + " " + .version | .result' 2>/dev/null | sed "s/^/  /g"
  echo `pwd` $(echo $STR3 | jq -r '. | .result = (.buildid|tostring) + " " + .version | .result' 2>/dev/null | wc -l) shsh saves
  exit
fi
echo
echo "Usage: bash Issue_SHSH_checker.sh [device MODEL] [ECID]"
echo
echo "  with one argument :) Issue SHSH check"
echo "   (bash Issue_SHSH_checker.sh iPhone10,3)"
echo "  with two arguments:) Get all issued SHSH"
echo "   (bash Issue_SHSH_checker.sh iPhone10,3 8237910564814894)"
echo



