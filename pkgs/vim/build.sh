#!/bin/sh
(
cd source || exit 1
vim_cv_memcpy_handles_overlap=set vim_cv_bcopy_handles_overlap=set vim_cv_memmove_handles_overlap=set vim_cv_stat_ignores_slash=set vim_cv_timer_create=set vim_cv_getcwd_broken=set vim_cv_toupper_broken=set vim_cv_terminfo=set vim_cv_tgetent=zero ./configure --host="$_TARGET" --prefix=/usr --with-tlib=ncurses
make -j4
make DESTDIR="$_PKGDIR/vim/package" STRIP="$_TARGET-strip" install
)

[ -d package ] || exit 1

(
cd package || exit 1
rm -rf usr/share/man
rm -rf usr/share/icons
rm -rf usr/share/applications
ldid -S"$_BSROOT/entitlements.plist" usr/bin/vim
ldid -S"$_BSROOT/entitlements.plist" usr/bin/xxd
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package vim-9.0.1128.deb
