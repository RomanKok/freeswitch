#!/bin/sh
##### -*- mode:shell-script; indent-tabs-mode:nil; sh-basic-offset:2 -*-

sdir="."
[ -n "${0%/*}" ] && sdir="${0%/*}"
. $sdir/common.sh

basedir=$(pwd);

(mkdir -p rpmbuild && cd rpmbuild && mkdir -p SOURCES BUILD BUILDROOT i386 x86_64 SPECS)

if [ ! -d "$basedir/../freeswitch-sounds" ]; then
	cd $basedir/..
	git clone https://stash.freeswitch.org/scm/fs/freeswitch-sounds.git 
else
	cd $basedir/../freeswitch-sounds
	git clean -fdx
        git pull
fi

cd $basedir/../freeswitch-sounds/sounds/trunk
./dist.pl fr/ca/june

mv freeswitch-sounds-fr-ca-june-*.tar.* $basedir/rpmbuild/SOURCES

cd $basedir

rpmbuild --define "_topdir %(pwd)/rpmbuild" \
  --define "_rpmdir %{_topdir}" \
  --define "_srcrpmdir %{_topdir}" \
  -ba freeswitch-sounds-fr-ca-june.spec

mkdir $src_repo/RPMS
mv $src_repo/rpmbuild/*/*.rpm $src_repo/RPMS/.

cat 1>&2 <<EOF
----------------------------------------------------------------------
The Sound RPMs have been rolled
----------------------------------------------------------------------
EOF