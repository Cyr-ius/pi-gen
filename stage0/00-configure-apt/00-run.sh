#!/bin/bash -e

install -m 644 files/sources.list ${ROOTFS_DIR}/etc/apt/
install -m 644 files/raspi.list ${ROOTFS_DIR}/etc/apt/sources.list.d/
[ "$IPOCUS_REPOS" = true ] && install -m 644 files/ipocus.list ${ROOTFS_DIR}/etc/apt/sources.list.d/

if [ -n "$APT_PROXY" ]; then
	install -m 644 files/51cache ${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache
	sed ${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache -i -e "s|APT_PROXY|${APT_PROXY}|"
else
	rm -f ${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache
fi

on_chroot apt-key add - < files/raspberrypi.gpg.key
[ "$IPOCUS_REPOS" = true ] && on_chroot apt-key add - < files/ipocus.gpg.key
on_chroot << EOF
apt-get update
apt-get dist-upgrade -y
EOF
