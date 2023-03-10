#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" src/grep "$_PKGROOT"/package/usr/bin
"$_CP" src/egrep "$_PKGROOT"/package/usr/bin
"$_CP" src/fgrep "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/grep
ldid -S"$_BSROOT/entitlements.xml" usr/bin/grep
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package grep-3.9.deb
