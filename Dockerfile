FROM centos:7
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SSPORT=8388
ENV SSPASSWD=sspassword

EXPOSE 22
EXPOSE $SSPORT

RUN yum update -y

#��װopenssh-server
RUN yum install -y openssh-server
RUN mkdir /var/run/sshd 
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
CMD ["/usr/sbin/sshd", "-D"] 

#��װshadowsocks
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks
ADD shadowsocks.json /etc/

#��װproxychains-ng
RUN yum install -y git gcc make
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
RUN chmod +x /usr/bin/startup.sh

RUN echo "root:docker" | chpasswd 
ENTRYPOINT ["/usr/bin/startup.sh"]