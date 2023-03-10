#!/bin/sh
(
cd source || exit 1
CC="$_TARGET-clang" SIZE="$_TARGET-size" sh Build.sh -r
mkdir -p "$_PKGROOT"/package/bin
"$_CP" mksh "$_PKGROOT"/package/bin
)

(
cd package || exit 1
"$_TARGET-strip" bin/mksh
ldid -S"$_BSROOT/entitlements.xml" bin/mksh
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package mksh-59c.deb
