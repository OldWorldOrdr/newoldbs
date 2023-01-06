#!/bin/sh
(
mkdir -p package/usr/bin
cd source || exit 1
arm-apple-darwin9-clang -pedantic -std=c99 -D_POSIX_C_SOURCE=200809L -D_DARWIN_C_SOURCE -O2 vi.c -o ../package/usr/bin/vi
)

(
cd package || exit 1
arm-apple-darwin9-strip -x usr/bin/vi
ldid -S usr/bin/vi
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nextvi-1.0.deb