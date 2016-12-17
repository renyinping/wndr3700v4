@echo off

start ping 192.168.1.1 -t

echo 路由断电，按住reset键不放，通电并观察电源指示灯，等到由黄色闪烁变为绿色闪烁，松开reset键
pause

@tftp -i 192.168.1.1 put releases\openwrt-usb-15.05.1-ar71xx-nand128-wndr3700v4-ubi-factory.img

echo 30/30/30复位 ：
echo 按住复位键30秒钟，且不要释放它。
echo 保持按住复位键，拔掉路由器电源，等待30秒以上。
echo 仍然按住复位键，重新插入路由器电源，并等待30秒。
echo 再次拔掉路由器电源，并松开复位键。
echo 插入路由器电源，然后等待至少1分钟。这是至关重要的，因为路由器正在构建NVRAM设置。

pause
