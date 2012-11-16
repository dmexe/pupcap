set -e

test -e /root/.pupcap_prepare_ok -a ${PUPCAP_FORCE} = "0" && exit 0

if [ ! -e /root/.pupcap_prepare_locale_ok -o ${PUPCAP_FORCE} = "1"  ]; then
  locale-gen && update-locale LANG=en_US.UTF8 && touch /root/pupcap_prepare_locale_ok
fi

SOURCES_LIST=/etc/apt/sources.list

SOURCES_LIST_MD5=`md5sum ${SOURCES_LIST} | awk '{ print $1 }'`

if [ "$SOURCES_LIST_MD5" != "0af83b87b34bcdebf8a81a7ccc523e26" -o ${PUPCAP_FORCE} = "1" ]; then

  cat <<EOF > ${SOURCES_LIST}
#############################################################
################### OFFICIAL UBUNTU REPOS ###################
#############################################################

###### Ubuntu Main Repos
deb mirror://mirrors.ubuntu.com/mirrors.txt precise main
deb-src mirror://mirrors.ubuntu.com/mirrors.txt precise main

###### Ubuntu Update Repos
deb mirror://mirrors.ubuntu.com/mirrors.txt precise-security main
deb mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main
deb-src mirror://mirrors.ubuntu.com/mirrors.txt precise-security main
deb-src mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main
EOF
  echo >> ${SOURCES_LIST} # new line

  chown root:root ${SOURCES_LIST}
  chmod 0644 ${SOURCES_LIST}
fi

apt-get -qy update > /dev/null
apt-get install -qy rsync wget rubygems vim git-core build-essential > /dev/null
apt-get -qy clean

/usr/bin/gem install -q --no-ri --no-rdoc --version '~> 2.7.1' puppet
touch /root/.pupcap_prepare_ok

