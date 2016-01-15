#! /bin/bash
KALAN_DIR="$HOME/kalan"
repodir="$KALAN_DIR-repo-deb"
if [ ! -d $repodir ];then
  mkdir -p $repodir
fi
dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-all-apt-get.fil
sudo rsync -aAXv --exclude 'lock' /var/cache/apt/archives/* $repodir
localdeblist=$(ls $repodir)
let ntotal=0
let nfound=0
let nmissing=0
>$KALAN_DIR-data/missing-all-apt-get.fil
while read packagename; do
  debversion="$(dpkg -s $packagename | grep 'Version' | awk -F' ' '{print $2}')"
  fullfilename="$packagename" 
  fullfilename=${fullfilename}_
  fullfilename="$fullfilename$debversion"
  fullfilename="$fullfilename.deb"
  if [ -e $repodir/$fullfilename ];then
    echo "have it: $fullfilename"
    let nfound=nfound+1
  else
    echo "missing: $fullfilename"
    let nmissing=nmissing+1
    echo "$fullfilename" >> $KALAN_DIR-data/missing-all-apt-get.fil
  fi
  let ntotal=ntotal+1
done <$KALAN_DIR-data/result-all-apt-get.fil

for itdeb in localdeblist ; do
   echo $itdeb
done
cd $repodir
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
echo "Total installed: $ntotal"
echo "already in repo: $nfound"
echo "missing        : $nmissing"
