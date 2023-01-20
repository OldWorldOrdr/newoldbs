#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --disable-install-examples
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/bin
rm -rf usr/share
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package readline-8.2.1.deb
