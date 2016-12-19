# /bin/sh

WORK_DIR=`dirname $(readlink -f $0)`;
DL_DIR=/share/dl;
mkdir -p ${DL_DIR};

BASE='luci luci-i18n-chinese kmod-usb-storage block-mount usbutils blkid fdisk e2fsprogs kmod-fs-ext4 kmod-nls-utf8'
TOOLS='wget ca-certificates unzip tar bash hdparm'
SMB='luci-app-samba'
FAT32='kmod-fs-vfat kmod-nls-cp437 kmod-nls-iso8859-1 dosfsck mkdosfs dosfslabel'
EXFAT='kmod-fs-exfat'
NTFS='kmod-fs-ntfs'
F2FS='kmod-fs-f2fs libf2fs f2fs-tools'
BT='transmission-daemon luci-app-transmission transmission-web'
XXNET='python python-openssl pyopenssl wget ca-certificates unzip bash'

all()
{
	opkg install $BASE $TOOLS $SMB $BT;
}

base()
{
	opkg install $BASE $TOOLS;
}

smb()
{
	opkg install $SMB;
}

bt()
{
	opkg install $BT;
}

xxnet()
{
	opkg install $XXNET;
	TOP_DIR=/share/xx-net;
	
	## set version ##
	UPD_URL='https://github.com/XX-net/XX-Net/raw/master/code/default/update_version.txt';
	UPD_FILE=${DL_DIR}/${UPD_URL##*/};
	wget -O  ${UPD_FILE} ${UPD_URL};
	ZIP_URL=`sed -n '/Stable/{n;p}' ${UPD_FILE}`;
	VERSION=${ZIP_URL##*/}; VERSION=${VERSION%%\ *};
	echo "Version = ${VERSION}";
	
	## unpack ##
	echo 'Unpack...';
	ZIP_FILE=${DL_DIR}/${VERSION}.zip;
	[ ! -f "${ZIP_FILE}" ] && wget  -O ${ZIP_FILE} ${ZIP_URL};
	rm -rf ${TOP_DIR%/*}/XX-Net-${VERSION};
	unzip -q ${ZIP_FILE} -d ${TOP_DIR%/*};
	rm -rf ${TOP_DIR};
	mv ${TOP_DIR%/*}/XX-Net-${VERSION} ${TOP_DIR};
	
	## xx-net data ##
	ln -s ${TOP_DIR%/*}/xx-net-data ${TOP_DIR}/data;
	
	## rc.local ##
#	XXNET_S="python ${TOP_DIR}/code/default/local/proxy.py 2&> /dev/null &";
#	sed -i "/gae_proxy\/local\/proxy.py/d" /etc/rc.local;
	XXNET_S="${TOP_DIR}/start-mini";
	sed -i "/xx-net\/start-mini/d"         /etc/rc.local;
	sed -i "/^exit\ 0$/d"                  /etc/rc.local;
	echo "${XXNET_S}"                   >> /etc/rc.local;
	echo "exit 0"                       >> /etc/rc.local;
	
	## start-mini ##
	echo '
# /bin/sh
TOP_DIR=`dirname $(readlink -f $0)`
VERSION=`cat ${TOP_DIR}/code/version.txt`
echo "Version=${VERSION}"
python ${TOP_DIR}/code/${VERSION}/gae_proxy/local/proxy.py 2&> /dev/null &
exit
' > ${TOP_DIR}/start-mini;
	chmod a+x ${TOP_DIR}/start-mini;
}

################################################################
if [ -z "$1" ]; then
	cat $0 | grep \(\)$
else
	if [ `cat $0 | grep ^$1\(\)$ | wc -l` -eq 1 ]; then
		$*
	else
		echo "Invalid parameter"
	fi
fi
