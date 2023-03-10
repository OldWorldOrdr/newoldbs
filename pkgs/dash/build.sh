#!/bin/sh
(
cd source || exit 1
./autogen.sh
./configure --host="$_TARGET" --bindir=/bin
"$_MAKE" -j8
mkdir -p "$_PKGROOT"/package/bin
"$_CP" src/dash "$_PKGROOT"/package/bin
)

(
cd package || exit 1
"$_TARGET-strip" bin/dash
ldid -S"$_BSROOT/entitlements.xml" bin/dash
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package dash-0.5.12.deb
