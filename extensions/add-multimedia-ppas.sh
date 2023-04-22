#!/bin/bash
function pre_customize_image__006_add_multimedia_ppas() {
	display_alert "Adding multimedia PPAs" "${EXTENSION}" "info"
	chroot_sdcard add-apt-repository ppa:liujianfeng1994/panfork-mesa
	chroot_sdcard add-apt-repository ppa:liujianfeng1994/rockchip-multimedia
	chroot_sdcard apt-get update
	chroot_sdcard apt-get -y dist-upgrade
	chroot_sdcard apt-get -y install mali-g610-firmware rockchip-multimedia-config	
}
