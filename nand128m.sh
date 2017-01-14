#!/bin/bash


# 使用全部128M NAND 空间
nand128m()
{
	local FILE="target/linux/ar71xx/image/Makefile"
	[ ! -f "${FILE}" ] && print_error "File not found: ${FILE}" && return 1
	
	local OLD='wndr4300_mtdlayout=mtdparts=ar934x-nfc:256k(u-boot)ro,256k(u-boot-env)ro,256k(caldata),512k(pot),2048k(language),512k(config),3072k(traffic_meter),2048k(kernel),23552k(ubi),25600k@0x6c0000(firmware),256k(caldata_backup),-(reserved)'
	local NEW='wndr4300_mtdlayout=mtdparts=ar934x-nfc:256k(u-boot)ro,256k(u-boot-env)ro,256k(caldata),512k(pot),2048k(language),512k(config),3072k(traffic_meter),2048k(kernel),121856k(ubi),123904k@0x6c0000(firmware),256k(caldata_backup),-(reserved)'
	
#	sed -n  "/^${OLD}$/p"        ${FILE};
	sed -i "s/^${OLD}$/${NEW}/g" ${FILE};
#	sed -n  "/^${NEW}$/p"        ${FILE};
	[ `sed -n  "/^${NEW}$/p" ${FILE} | wc -l` -eq 1 ] && echo "WNDR4300/WNDR3700v4 NAND 128M OK."
}

nand128m

