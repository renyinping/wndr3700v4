FROM ubuntu:14.04

RUN apt-get update \
 && apt-get install -y \
        lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6 \
        build-essential ccache \
        libncurses5-dev libssl-dev \
        git subversion mercurial \
        unzip gawk screen tmux \
 && apt-get autoremove \
 && apt-get clean

RUN git clone https://github.com/renyinping/wndr3700v4.git \
 && cd wndr3700v4 \
 && git checkout openwrt \
 && git submodule init \
 && git submodule update \
 && cd openwrt-14.07 \
 && ./scripts/feeds update -a \
 && ./scripts/feeds install -a \
 && ../nfs-kernel-server.not-kmod \
 && ../nand128m.sh \
 && tar -zxvf ../config.tar.gz 
 
 RUN cd wndr3700v4/openwrt-14.07 && make
