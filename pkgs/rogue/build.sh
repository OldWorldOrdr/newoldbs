#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)


(
rm packagerogue.scr
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/rogue
ldid -S"$_BSROOT/entitlements.xml" usr/bin/rogue
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package rogue-5.4.4.deb
