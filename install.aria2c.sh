# /bin/bash

rm -rf /www/aria2
ln -s /share/webui-aria2/ /www/aria2

rm -rf /www/dl
ln -s /share/dl/ /www/dl

echo '
# /bin/sh
cd /www/dl && aria2c --enable-rpc --rpc-listen-all -D
exit
' > /www/aria2/start.sh

chmod a+x /share/webui-aria2/start.sh
