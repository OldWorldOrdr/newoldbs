#!/bin/sh
(
cd source || exit 1
./configure --host=arm-apple-darwin9 --prefix=/usr --sysconfdir=/etc --with-default-terminfo-dir=/usr/share/terminfo --with-shared --without-normal --without-debug --enable-sigwinch --disable-mixed-case --enable-termcap
make -j4
make DESTDIR=../../package install
make clean
./configure --host=arm-apple-darwin9 --prefix=/usr --sysconfdir=/etc --with-default-terminfo-dir=/usr/share/terminfo --with-shared --without-normal --without-debug --enable-sigwinch --disable-mixed-case --enable-termcap --disable-overwrite --enable-widec
make -j4
make DESTDIR=../../package install
)

(
cd package || exit 1
rm usr/bin/tabs
rm -rf usr/man
for i in tic tput tset toe clear infocmp; do
    arm-apple-darwin9-strip -x usr/bin/$i
    ldid -S usr/bin/$i
done
for i in usr/lib/*.dylib; do
    if [ -f "$i" ]; then
        arm-apple-darwin9-strip -x "$i"
    fi
done
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package ncurses-5.9.deb