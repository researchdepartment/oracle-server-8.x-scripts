#!/bin/bash
yum -y install wget mlocate yum-utils gcc gcc-c++ libevent kernel-devel zlib-devel libevent-devel perl-Module-Load-Conditional perl-core perl-Test-Harness systemd-devel openssl-devel git
yum -y groupinstall "Development Tools"
git clone https://git.torproject.org/tor.git
cd tor/
./autogen.sh
./configure --disable-asciidoc
make
make install
mv /usr/local/etc/tor/torrc.sample /usr/local/etc/tor/torrc
service tor start
