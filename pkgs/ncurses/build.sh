#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --with-default-terminfo-dir=/usr/share/terminfo --with-shared --without-normal --without-debug --enable-termcap --enable-symlinks
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
"$_MAKE" clean
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --with-default-terminfo-dir=/usr/share/terminfo --with-shared --without-normal --without-debug --enable-termcap --enable-symlinks --disable-overwrite --enable-widec
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/man usr/bin/tabs
(
cd usr/share/terminfo || exit 1
for i in ?; do
    x="$(printf %x \'"$i")"
    ln -sn "$i" "$x"
done
)
for i in tic tput tset toe clear infocmp; do
    "$_TARGET-strip" usr/bin/$i
    ldid -S"$_BSROOT/entitlements.xml" usr/bin/$i
done
for i in usr/lib/*.dylib; do
    if ! [ -h "$i" ]; then
        "$_TARGET-strip" -x "$i" -no_code_signature_warning
        ldid -S"$_BSROOT/entitlements.xml" "$i"
    fi
done
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package ncurses-5.9.deb
