@echo off

start ping 192.168.1.1 -t

echo ·�ɶϵ磬��סreset�����ţ�ͨ�粢�۲��Դָʾ�ƣ��ȵ��ɻ�ɫ��˸��Ϊ��ɫ��˸���ɿ�reset��
pause

@tftp -i 192.168.1.1 put releases\openwrt-usb-15.05.1-ar71xx-nand128-wndr3700v4-ubi-factory.img

echo 30/30/30��λ ��
echo ��ס��λ��30���ӣ��Ҳ�Ҫ�ͷ�����
echo ���ְ�ס��λ�����ε�·������Դ���ȴ�30�����ϡ�
echo ��Ȼ��ס��λ�������²���·������Դ�����ȴ�30�롣
echo �ٴΰε�·������Դ�����ɿ���λ����
echo ����·������Դ��Ȼ��ȴ�����1���ӡ�����������Ҫ�ģ���Ϊ·�������ڹ���NVRAM���á�

pause