#! /bin/bash
KALAN_DIR="$HOME/kalan"
repodir="$KALAN_DIR-repo-deb"
if [ ! -d $repodir ];then
  mkdir -p $repodir
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
  debversion="$(dpkg -s $packagename | grep 'Version' | awk -F' ' '{print $2}' | awk -F':' '{print $1}' )"
  fullfilename="$packagename" 
  fullfilename=${fullfilename}_
  fullfilename="$fullfilename$debversion"
  findinrepo=$(find $repodir -name "$fullfilename*.deb")
  if [[ -n "$findinrepo" ]];then
    echo "have it: $findinrepo"
    let nfound=nfound+1

  else
    findinrepo2="$(find $repodir -name "$fullfilename*.deb")"
    echo "$fullfilename" >> $KALAN_DIR-data/missing-all-apt-get.fil
    echo "getting package: $packagename" 
    echo "in repo: $findinrepo2" 
    apt-get download $packagename
    findinrepo3="$(find $repodir -name "$fullfilename*.deb")"
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
