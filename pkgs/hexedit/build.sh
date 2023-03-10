#!/bin/sh
(
cd source || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/hexedit
ldid -S"$_BSROOT/entitlements.xml" usr/bin/hexedit
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package hexedit-1.6.deb
