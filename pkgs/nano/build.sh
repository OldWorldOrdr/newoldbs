#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
make -j4
make DESTDIR="$_PKGDIR/nano/package" install
)

(
for nanorc in files/syntax/*.nanorc; do
    cp -a "$nanorc" package/usr/share/nano/
done
cp files/nanorc package/etc
cd package || exit 1
"$_TARGET-strip" -x usr/bin/nano
ldid -S"$_ENTITLEMENTS" usr/bin/nano
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nano-7.1.deb
