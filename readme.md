# 构建 WNDR3700v4 OpenWrt 系统
-----------------------------

选择系统及安装工具

    # ubuntu-14.04.4-server-amd64
    $ apt-get update 
    $ apt-get install -y \
          lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6 \
          build-essential ccache \
          libncurses5-dev libssl-dev \
          git subversion mercurial \
          unzip gawk screen tmux 
    $ apt-get autoremove
    $ apt-get clean

获取本仓库

    $ git clone https://github.com/renyinping/wndr3700v4.git && cd wndr3700v4
    $ git checkout openwrt
    $ git submodule init
    $ git submodule update

    $ cd openwrt-14.07
    $ ln -s ../src-dl dl    # 国内源码下载实在太慢而且老是出错
    $ ln -s ../files files  # 个人配置文件

更新OpenWrt包源码

    $ ./scripts/feeds update -a
    $ ./scripts/feeds install -a

去除`nfs-kernel-server`中的`kmod-fs-nfsd`和`kmod-fs-nfs`模块依赖，因为我们决定将`NFS-server`编译到Linux kernel中

    ../nfs-kernel-server.not-kmod

支持128M NAND flash

    $ ../nand128m.sh

清理配置文件和缓存

    $ rm -rf .config
    $ make clean

选择目标平台 `make menuconfig`，如果没有`.config`文件时执行`make clean`也会打开OpenWrt配置界面

    Target System ---> Atheros AR7xxx/AR9xxx
    Subtarget ---> Generic devices with NAND flash
    Target Profile ---> NETGEAR WNDR3700v4/WNDR4300

选择目标平台和设备后，执行命令 `make defconfig`

去除OpenWrt中的默认USB支持 `make menuconfig`，因为我们将在Linux kernel中直接添加USB驱动和存储支持

    Kernel modules ---> USB Support ---> < > kmod-usb-core
                                         < > kmod-usb-ohci
                                         < > kmod-usb2

    Kernel modules ---> Native Language Support ---> < > kmod-nls-base

添加LuCI支持

    LuCI ---> 1. Collections ---> <*> luci
    LuCI ---> 5. Translations ---> <*> luci-i18n-chinese

添加证书和基础命令工具

    Base system ---> <*> block-mount
    Base system ---> <*> ca-certificates

    Network ---> File Transfer ---> <*> wget

    Utilities ---> Compression ---> <*> unzip

    Utilities ---> Filesystem ---> <*> e2fsprogs

    Utilities ---> disc ---> <*> blkid
                             <*> fdisk
                             <*> hdparm

    Utilities ---> <*> bash
                   <*> bash-completion
                   <*> tar
                   <*> usbutils

添加网络文件系统服务 NFS 和 SAMBA，`nfs-kernel-server`需要配合`../nfs-kernel-server.not-kmod`并启用Linux kernel支持

    Network ---> Filesystem ---> <*> nfs-kernel-server 
    Network ---> <*> samba36-server

启用浮点(FPU)仿真 `make kernel_menuconfig`

    [*] Enable FPU emulation

配置Linux kernel支持USB驱动及USB存储设备支持 `make kernel_menuconfig`

    Device Drivers ---> SCSI device support ---> <*> SCSI device support
                                                 <*> SCSI disk support

    Device Drivers ---> [*] USB support ---> --- USB support
                                             <*>   Support for Host-side USB
                                             <*>     EHCI HCD (USB 2.0) support
                                             <*>     OHCI HCD support
                                             <*>     USB Mass Storage support

配置EXT4文件系统支持 `make Kernel_menuconfig`

    File system ---> <*> The Extended 4 (ext4) filesystem
                     [*]   Use ext4 for ext2/ext3 file system # 对ext2/ext3文件系统使用ext4

配置VFAT文件系统支持 `make Kernel_menuconfig`

    File system ---> DOS/FAT/NT Filesystems ---> <*> VFAT (Windows-95) fs support
                                                 (936) Default codepage for FAT
                                                 (utf8) Default iocharset for FAT

配置语言编码支持 `make Kernel_menuconfig`，根据自己需要调整

    File system ---> -*- Native language support ---> --- Native language support
                                                         (utf8) Default NLS Option
                                                         <*> Codepage 437
                                                         <*> Simplified Chinese charset (CP936, GB2312)
                                                         <*> Traditional Chinese charset (Big5)
                                                         <*> ASCII
                                                         <*> NLS ISO 8859-1
                                                         <*> NLS UTF-8

配置NFS网络文件系统支持 `make Kernel_menuconfig`

    File system ---> [*] Network File Systems ---> --- Network File Systems
                                                   <*>   NFS server support 
                                                   -*-     NFS server support for NFS version 3
                                                   [*]     NFS server support for NFS version 4

