#!/bin/sh
(
cd source || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/usr --without-fonts
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" cmatrix "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/cmatrix
ldid -S"$_BSROOT/entitlements.xml" usr/bin/cmatrix
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package cmatrix-2.0.deb
