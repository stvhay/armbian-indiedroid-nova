#!/bin/bash
function pre_customize_image__007_add_bluetooth() {
	local TMPDIR
	display_alert "Adding bluetooth support" "${EXTENSION}" "info"

	# Build firmware
	TMPDIR=$(mktemp -d)
	pushd "${TMPDIR}" || exit 1
		git clone https://github.com/stvhay/rkwifibt || exit 1
		cd rkwifibt                                  || exit 1
		make -C realtek/rtk_hciattach                || exit 1
		# Install the firmware and utility
		mkdir -p "${SDCARD}/lib/firmware/rtl_bt"
		cp -fr realtek/RTL8821CS/*                 "${SDCARD}/lib/firmware/rtl_bt/"
		cp -f  realtek/rtk_hciattach/rtk_hciattach "${SDCARD}/usr/bin/"
		cp -f  bt_load_rtk_firmware                "${SDCARD}/usr/bin/"
		chroot_sdcard chmod +x /usr/bin/{rtk_hciattach,bt_load_rtk_firmware}
		echo hci_uart >> "${SDCARD}/etc/modules"
	popd || exit 1

	# Systemd service
	cat > "${SDCARD}/etc/systemd/system/bluetooth-rtl8821cs.service" <<- EOD
		[Unit]
		Description=RTL8821CS Firmware Service
		After=network.target

		[Service]
		Type=oneshot
		Environment=BT_TTY_DEV=/dev/ttyS9
		ExecStart=/usr/bin/bt_load_rtk_firmware
		RemainAfterExit=true
		StandardOutput=journal

		[Install]
		WantedBy=multi-user.target
	EOD
	chroot_sdcard systemctl enable bluetooth-rtl8821cs.service
}
