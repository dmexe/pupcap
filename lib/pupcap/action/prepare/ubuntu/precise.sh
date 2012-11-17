set -e
set -v

if test -e /root/.pupcap_prepare_ok -a "x${PUPCAP_FORCE}" = "x0"
then
  exit 0
fi

CURRENT_LANG=`locale | awk '/LANG=/{ split($1, a, "=") ; print a[2] }'`
if test "x${CURRENT_LANG}" != "xen_US.UTF-8"
then
  locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
fi

if test -n "${PUPCAP_HOSTNAME}"
then
  echo ${PUPCAP_HOSTNAME} > /etc/hostname
  cat /etc/hosts | grep ${PUPCAP_HOSTNAME} || echo "127.0.0.1  ${PUPCAP_HOSTNAME}" >> /etc/hosts && /usr/sbin/service hostname start
fi

SOURCES_LIST=/etc/apt/sources.list

SOURCES_LIST_MD5=`md5sum ${SOURCES_LIST} | awk '{ print $1 }'`

if test "$SOURCES_LIST_MD5" != "14846cd43a3ef58b204b0807fa4856f8"
then

  cp -f ${SOURCES_LIST} ${SOURCES_LIST}.pupcap_back

  cat <<EOF > ${SOURCES_LIST}
#############################################################
################### OFFICIAL UBUNTU REPOS ###################
#############################################################

###### Ubuntu Main Repos
deb http://us.archive.ubuntu.com/ubuntu/ precise main
deb-src http://us.archive.ubuntu.com/ubuntu/ precise main

###### Ubuntu Update Repos
deb http://us.archive.ubuntu.com/ubuntu/ precise-security main
deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main
deb-src http://us.archive.ubuntu.com/ubuntu/ precise-security main
deb-src http://us.archive.ubuntu.com/ubuntu/ precise-updates main
EOF
  echo >> ${SOURCES_LIST} # new line

  chown root:root ${SOURCES_LIST}
  chmod 0644 ${SOURCES_LIST}
fi

apt-get -qy update > /dev/null
apt-get install -qy rsync wget rubygems vim git-core build-essential > /dev/null
apt-get -qy clean

/usr/bin/gem install -q --no-ri --no-rdoc --version '~> 2.7.1' puppet
/usr/bin/gem install -q --no-ri --no-rdoc librarian-puppet

/usr/sbin/groupadd -f puppet

touch /root/.pupcap_prepare_ok

