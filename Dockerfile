FROM oraclelinux:7.1

MAINTAINER Stas Alekseev <stas.alekseev@gmail.com>

ENV ZOOKEEPER_VERSION 3.4.6
ENV JAVA_VERSION 1.7.0
EXPOSE 2181 2888 3888

RUN yum --enablerepo ol7_optional_latest -y --color=never install \
      wget \
      tar \
      bind-utils \
      java-${JAVA_VERSION}-openjdk-headless \
    && wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-${ZOOKEEPER_VERSION} /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /opt/zookeeper/{data,log} \
    && yum -y --color=never autoremove \
      wget \
      tar \
    && yum -y --color=never clean all

WORKDIR /opt/zookeeper
VOLUME ["/opt/zookeeper/conf", "/opt/zookeeper/data", "/opt/zookeeper/log"]

COPY config-and-run.sh ./bin/
COPY zoo.cfg ./conf/

CMD ["/opt/zookeeper/bin/config-and-run.sh"]
