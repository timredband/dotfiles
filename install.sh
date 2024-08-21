#!/usr/bin/bash

mkdir install
pushd install

mkdir test_bin

# DESTINATION=$HOME/.local/bin/.
DESTINATION=test_bin

# will need to manually install jq
# curl -s https://api.github.com/repos/jqlang/jq/releases |
# 	jq '[.[]| select(.prerelease == false)][0] | .assets[] | select(.name == "jq-linux64").browser_download_url' |
# 	xargs wget && mv jq-linux64 test_bin/jq && chmod +x $DESTINATION/jq

curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases |
  jq -r '[.[]| select(.prerelease == false)][0] |
        "https://github.com/BurntSushi/ripgrep/releases/download/"+.name+"/ripgrep-"+.name+"-x86_64-unknown-linux-musl.tar.gz"' |
  tee url.txt |
  xargs wget
URL=$(head -1 url.txt)
TAR_NAME=$(head -1 url.txt | cut -d "/" -f 9)
echo $TAR_NAME
FOLDER=$(echo -n $TAR_NAME | sed s/.tar.gz//)
echo $FOLDER
echo -n $TAR_NAME | xargs tar -xzvf && mv ./$FOLDER/rg $DESTINATION

curl -s https://api.github.com/repos/sharkdp/fd/releases |
  jq -r '[.[]| select(.prerelease == false)][0] |
  "https://github.com/sharkdp/fd/releases/download/"+.name+"/fd-"+.name+"-x86_64-unknown-linux-gnu.tar.gz"' |
  tee url.txt |
  xargs wget
URL=$(head -1 url.txt)
TAR_NAME=$(head -1 url.txt | cut -d "/" -f 9)
echo $TAR_NAME
FOLDER=$(echo -n $TAR_NAME | sed s/.tar.gz//)
echo $FOLDER
echo -n $TAR_NAME | xargs tar -xzvf && mv ./$FOLDER/fd $DESTINATION

curl -s https://api.github.com/repos/ahmetb/kubectx/releases |
  jq -r '[.[]| select(.prerelease == false)][0] |
  "https://github.com/ahmetb/kubectx/releases/download/"+.name+"/kubectx_"+.name+"_linux_x86_64.tar.gz"' |
  tee url.txt |
  xargs wget
URL=$(head -1 url.txt)
TAR_NAME=$(head -1 url.txt | cut -d "/" -f 9)
echo $TAR_NAME
FOLDER=$(echo -n $TAR_NAME | sed s/.tar.gz//)
echo $FOLDER
echo -n $TAR_NAME | xargs tar -xzvf && mv kubectx $DESTINATION
#
curl -s https://api.github.com/repos/ahmetb/kubectx/releases |
  jq -r '[.[]| select(.prerelease == false)][0] |
  "https://github.com/ahmetb/kubectx/releases/download/"+.name+"/kubens_"+.name+"_linux_x86_64.tar.gz"' |
  tee url.txt |
  xargs wget
URL=$(head -1 url.txt)
TAR_NAME=$(head -1 url.txt | cut -d "/" -f 9)
echo $TAR_NAME
FOLDER=$(echo -n $TAR_NAME | sed s/.tar.gz//)
echo $FOLDER
echo -n $TAR_NAME | xargs tar -xzvf && mv kubens $DESTINATION

curl -s https://api.github.com/repos/junegunn/fzf/releases |
  jq -r '[.[]| select(.prerelease == false)][0] |
  "https://github.com/junegunn/fzf/releases/download/"+.tag_name+"/fzf-"+.name+"-linux_amd64.tar.gz"' |
  tee url.txt |
  xargs wget
URL=$(head -1 url.txt)
TAR_NAME=$(head -1 url.txt | cut -d "/" -f 9)
echo $TAR_NAME
FOLDER=$(echo -n $TAR_NAME | sed s/.tar.gz//)
echo $FOLDER
echo -n $TAR_NAME | xargs tar -xzvf && mv fzf $DESTINATION

curl -s https://api.github.com/repos/derailed/k9s/releases |
  jq -r '[.[]| select(.prerelease == false)][0] |
  "https://github.com/derailed/k9s/releases/download/"+.name+"/k9s_Linux_amd64.tar.gz"' |
  tee url.txt |
  xargs wget
URL=$(head -1 url.txt)
TAR_NAME=$(head -1 url.txt | cut -d "/" -f 9)
echo $TAR_NAME
FOLDER=$(echo -n $TAR_NAME | sed s/.tar.gz//)
echo $FOLDER
echo -n $TAR_NAME | xargs tar -xzvf && mv k9s $DESTINATION

curl -s https://api.github.com/repos/MordechaiHadad/bob/releases |
  jq -r '[.[]| select(.prerelease == false)][0] |
  "https://github.com/MordechaiHadad/bob/releases/download/"+.name+"/bob-linux-x86_64-openssl.zip"' |
  tee url.txt |
  xargs wget
URL=$(head -1 url.txt)
TAR_NAME=$(head -1 url.txt | cut -d "/" -f 9)
echo $TAR_NAME
FOLDER=$(echo -n $TAR_NAME | sed s/.zip//)
echo $FOLDER
echo -n $TAR_NAME | xargs unzip && mv ./$FOLDER/bob $DESTINATION && chmod +x $DESTINATION/bob

popd
