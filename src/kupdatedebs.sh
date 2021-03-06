#! /bin/bash
KALAN_DIR="$HOME/kalan"
repodir="/var/kalan-repo-deb"
source $KALAN_DIR/src/kalan-lib.sh
if [ ! -d $repodir ];then
  sudo mkdir -p $repodir
fi
dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 | awk -F':' '{print $1}'> $KALAN_DIR-data/result-all-apt-get.fil
sudo rsync -aAXv --exclude 'lock' /var/cache/apt/archives/* $repodir
localdeblist=$(ls $repodir)
let ntotal=0
let nfound=0
let nmissing=0
>$KALAN_DIR-data/missing-all-apt-get.fil
cd $repodir
while read packagename; do
  #debversion="$(dpkg -s $packagename | grep 'Version' | awk -F' ' '{print $2}' | awk -F':' '{print $1}' )"
  debversion="$(dpkg -s $packagename | grep 'Version' | awk -F' ' '{print $2}' )"
  orig="AxxBCyyyDEFzzLMN"
  debversionfile=${debversion//:/\:}
  fullfilename="$packagename" 
  fullfilename=${fullfilename}_
  fullpackagename="$fullfilename$debversion"
  fullfilename="$fullfilename$debversionfile"
  echo "checking for: $fullfilename*.deb"
  findinrepo=$(find $repodir -name "$fullfilename*.deb")
  if [[ -n "$findinrepo" ]];then
    echo "have it: $findinrepo"
    let nfound=nfound+1

  else
    findinrepo2=$(find $repodir -name "${packagename}_*.deb")
    echo "$fullfilename" >> $KALAN_DIR-data/missing-all-apt-get.fil
    echo "getting package: $packagename version: $debversion " 
    echo "in repo: $findinrepo2" 
    if [[ $debversion == *['!'@#\$%^\&*()_+:]* ]];then
       sudo apt-get --no-install-recommends download $packagename
    else
       sudo apt-get --no-install-recommends download $packagename=$debversion
    fi
    
      findinrepo3=$(find $repodir -name "${packagename}_*.deb")
    echo "after dl : $findinrepo3"
    let nmissing=nmissing+1
  fi

  let ntotal=ntotal+1
done <$KALAN_DIR-data/result-all-apt-get.fil

for itdeb in localdeblist ; do
   echo $itdeb
done

dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
echo "Total installed: $ntotal"
echo "already in repo: $nfound"
echo "missing        : $nmissing"

localrepsource="deb file:$repodir ./"
if [[ -z $(grep "$localrepsource" /etc/apt/sources.list) ]]; then 
     sudo sh -c echo "$localrepsource"  >> /etc/apt/sources.list
     echo "Adding local repo"
fi
        
