FROM centos:7
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SSPORT=8388
ENV SSPASSWD=sspassword

EXPOSE $SSPORT

RUN echo "root:docker" | chpasswd 

#��װshadowsocks
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks
ADD shadowsocks.json /etc/

#��װproxychains-ng
RUM yum install -y git gcc make
RUN cd /tmp && git clone --depth=1 https://github.com/rofl0r/proxychains-ng.git
WORKDIR /tmp/proxychains-ng
RUN ./configure --prefix=/usr --sysconfdir=/etc && make install && make install-config
WORKDIR /
ADD proxychains.conf /etc/proxychains.conf

#��װlantern_linux_amd64
RUN yum install -y wget
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 

#���������ű�
ADD startup.sh /usr/bin/startup.sh
chmod +x /usr/bin/startup.sh

ENTRYPOINT ["/usr/bin/startup.sh"]