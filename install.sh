#!/usr/bin/bash

mkdir install
pushd install

mkdir test_bin

# DESTINATION=$HOME/.local/bin/.
DESTINATION=test_bin

# Check is jq is installed since it will need to be installed manually.
if ! command -v jq &>/dev/null; then
  echo "jq must be installed. See https://github.com/jqlang/jq/releases"
  exit 1
else
  jq --version
fi

function get_latest_version() {
  curl -s "$1" |
    jq -r "$2" |
    tee url.txt |
    xargs wget
}

function extract() {
  TAR_NAME=$(head -1 url.txt | cut -d "/" -f 9)
  echo $TAR_NAME
  FOLDER=$(echo -n $TAR_NAME | sed s/.tar.gz//)
  echo $FOLDER
  echo -n $TAR_NAME | xargs tar -xzvf
}

function unzip() {
  ZIP_NAME=$(head -1 url.txt | cut -d "/" -f 9)
  echo $ZIP_NAME
  FOLDER=$(echo -n $ZIP_NAME | sed s/.zip//)
  echo $FOLDER
  echo -n $ZIP_NAME | xargs unzip
}

get_latest_version https://api.github.com/repos/BurntSushi/ripgrep/releases \
  '[.[]| select(.prerelease == false)][0] |
  "https://github.com/BurntSushi/ripgrep/releases/download/"+.name+"/ripgrep-"+.name+"-x86_64-unknown-linux-musl.tar.gz"'
extract
mv ./$FOLDER/rg $DESTINATION

get_latest_version https://api.github.com/repos/sharkdp/fd/releases \
  '[.[]| select(.prerelease == false)][0] |
  "https://github.com/sharkdp/fd/releases/download/"+.name+"/fd-"+.name+"-x86_64-unknown-linux-gnu.tar.gz"'
extract
mv ./$FOLDER/fd $DESTINATION

get_latest_version https://api.github.com/repos/ahmetb/kubectx/releases \
  '[.[]| select(.prerelease == false)][0] |
  "https://github.com/ahmetb/kubectx/releases/download/"+.name+"/kubectx_"+.name+"_linux_x86_64.tar.gz"'
extract
mv kubectx $DESTINATION

get_latest_version https://api.github.com/repos/ahmetb/kubectx/releases \
  '[.[]| select(.prerelease == false)][0] |
  "https://github.com/ahmetb/kubectx/releases/download/"+.name+"/kubens_"+.name+"_linux_x86_64.tar.gz"'
extract
mv kubens $DESTINATION

get_latest_version https://api.github.com/repos/junegunn/fzf/releases \
  '[.[]| select(.prerelease == false)][0] |
  "https://github.com/junegunn/fzf/releases/download/"+.tag_name+"/fzf-"+.name+"-linux_amd64.tar.gz"'
extract
mv fzf $DESTINATION

get_latest_version https://api.github.com/repos/derailed/k9s/releases \
  '[.[]| select(.prerelease == false)][0] |
  "https://github.com/derailed/k9s/releases/download/"+.name+"/k9s_Linux_amd64.tar.gz"'
extract
mv k9s $DESTINATION

get_latest_version https://api.github.com/repos/MordechaiHadad/bob/releases \
  '[.[]| select(.prerelease == false)][0] |
  "https://github.com/MordechaiHadad/bob/releases/download/"+.name+"/bob-linux-x86_64-openssl.zip"'
unzip
mv ./$FOLDER/bob $DESTINATION && chmod +x $DESTINATION/bob

popd
