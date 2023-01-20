#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
mkdir -p "$_PKGROOT/package/usr/bin"
mkdir -p "$_PKGROOT/package/bin"
"$_CP" less "$_PKGROOT/package/usr/bin"
"$_CP" lessecho "$_PKGROOT/package/usr/bin"
"$_CP" lesskey "$_PKGROOT/package/usr/bin"
ln -s less "$_PKGROOT/package/usr/bin/more"
ln -s ../usr/bin/more "$_PKGROOT/package/bin/more"
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/less
"$_TARGET-strip" -x usr/bin/lessecho
"$_TARGET-strip" -x usr/bin/lesskey
ldid -S"$_BSROOT/entitlements.xml" usr/bin/less
ldid -S"$_BSROOT/entitlements.xml" usr/bin/lessecho
ldid -S"$_BSROOT/entitlements.xml" usr/bin/lesskey
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package less-608.deb
