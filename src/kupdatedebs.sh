#! /bin/bash
KALAN_DIR="$HOME/kalan"
repodir="$KALAN_DIR-repo-deb"
if [ ! -d $repodir ];then
  mkdir -p $repodir
fi
dpkg -l | grep ^ii | sed 's_  _\t_g' | cut -f 2 > $KALAN_DIR-data/result-all-apt-get.fil
sudo rsync -aAXv /var/cache/apt/archives/* $repodir
localdeblist=$(ls $repodir)
for itdeb in localdeblist ; do
   echo $itdeb
done
cd $repodir
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

