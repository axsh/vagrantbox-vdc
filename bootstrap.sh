#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

function yum() {
  $(type -P yum) --disablerepo=updates "${@}"
}

# Add installation packages ...
addpkgs="
 man ntp ntpdate
 sudo rsync git make
 vim-minimal screen
 nmap lsof strace tcpdump traceroute telnet ltrace dnsutils sysstat nc
 wireshark
 httpd
 gcc

 git make sudo rpm-build rpmdevtools yum-utils tar
"

if [[ -n "$(echo ${addpkgs})" ]]; then
  yum install -y ${addpkgs}
fi

# 

rpm -qa epel-release* | egrep -q epel-release || { rpm -Uvh http://dlc.wakame.axsh.jp.s3-website-us-east-1.amazonaws.com/epel-release; }
rpm -qi rabbitmq-server || { yum install -y https://www.rabbitmq.com/releases/rabbitmq-server/v2.7.1/rabbitmq-server-2.7.1-1.noarch.rpm; }

cd /tmp
[[ -d wakame-vdc ]] || git clone https://github.com/axsh/wakame-vdc wakame-vdc
cd wakame-vdc

yum-builddep -y rpmbuild/SPECS/*.spec
