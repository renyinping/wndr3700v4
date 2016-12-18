# /bin/sh

WORK_DIR=`dirname $(readlink -f $0)`
TOP_DIR=${WORK_DIR}/xx-net
DL_DIR=${WORK_DIR}/dl
mkdir -p ${DL_DIR}

# install packages

XXNET_IPK="wget ca-certificates unzip screen"
XXNET_IPK="${XXNET_IPK} python-light libpthread zlib python-base libffi libbz2"
XXNET_IPK="${XXNET_IPK} python-logging python-codecs"
XXNET_IPK="${XXNET_IPK} python-openssl libopenssl"
opkg install ${XXNET_IPK}

# set version
UPD_URL='https://github.com/XX-net/XX-Net/raw/master/code/default/update_version.txt'
UPD_FILE=${DL_DIR}/${UPD_URL##*/}
wget -O  ${UPD_FILE} ${UPD_URL}
ZIP_URL=`sed -n '/Stable/{n;p}' ${UPD_FILE}`
VERSION=${ZIP_URL##*/}
VERSION=${VERSION%%\ *}
mkdir -p ${TOP_DIR}/code
echo ${VERSION} > ${TOP_DIR}/code/version.txt

# set ver_dir
VER_DIR=${TOP_DIR}/code/${VERSION}
rm -rf   ${VER_DIR}
mkdir -p ${VER_DIR}

# unpack
ZIP_FILE=${DL_DIR}/${VERSION}.zip
[ ! -f "${ZIP_FILE}" ] && wget  -O ${ZIP_FILE} ${ZIP_URL}
rm -rf ${DL_DIR}/XX-Net-${VERSION}
unzip -q ${ZIP_FILE} -d ${DL_DIR}
UNPACK_DIR=${DL_DIR}/XX-Net-${VERSION}/code/default

# move
GAE_DIR=${VER_DIR}/gae_proxy
LIB_DIR=${VER_DIR}/python27/1.0/lib
mkdir -p ${GAE_DIR}
mkdir -p ${LIB_DIR}
mv       ${UNPACK_DIR}/gae_proxy/local ${GAE_DIR}/
mv       ${UNPACK_DIR}/python27/1.0/lib/noarch ${LIB_DIR}/

# data
mkdir -p ${TOP_DIR}/data/gae_proxy
mkdir -p ${TOP_DIR}/data/launcher
mkdir -p ${TOP_DIR}/data/OpenSSL

# PyOpenSSL
rm -rf                           ${GAE_DIR}/local/OpenSSL
ln -s    ${TOP_DIR}/data/OpenSSL ${GAE_DIR}/local/OpenSSL

# clean
rm -rf ${DL_DIR}/XX-Net-${VERSION}
# rm -rf ${DL_DIR}

# rc.local
XXNET_S="python ${GAE_DIR}/local/proxy.py 2&> /dev/null &"
sed -i "/gae_proxy\/local\/proxy.py/d" /etc/rc.local
sed -i "/^exit\ 0$/d"                  /etc/rc.local
echo "${XXNET_S}"                   >> /etc/rc.local
echo "exit 0"                       >> /etc/rc.local

# start-mini
echo '
# /bin/sh
TOP_DIR=`dirname $(readlink -f $0)`
VERSION=`cat ${TOP_DIR}/code/version.txt`
echo "Version=${VERSION}"
python ${TOP_DIR}/code/${VERSION}/gae_proxy/local/proxy.py 2&> /dev/null &
exit
' > xx-net/start-mini
chmod a+x xx-net/start-mini

