# /bin/sh

FILE='/share/wndr3700v4/files.tar.gz'
rm -rf ${FILE}
cd /overlay && tar -zcvf ${FILE} --exclude=share *
