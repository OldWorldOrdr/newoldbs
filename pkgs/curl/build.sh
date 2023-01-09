#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --with-openssl
make -j4
make DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share/man
"$_TARGET-strip" -x usr/bin/curl
"$_TARGET-strip" -x usr/lib/libcurl.4.dylib
ldid -S"$_BSROOT/entitlements.plist" usr/bin/curl
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package curl-7.87.0.deb