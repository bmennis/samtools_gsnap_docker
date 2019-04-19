FROM ubuntu:18.04

ENV SAMTOOLS_VERSION 1.9
ENV HTSLIB_VERSION 1.9
ENV GSNAP_VERSION 2019-03-15

RUN apt update \
  && apt install --yes \
    make \
    g++ \
    zlib1g-dev \
    libbz2-dev \
    wget \
    perl \
  && wget http://research-pub.gene.com/gmap/src/gmap-gsnap-${GSNAP_VERSION}.tar.gz \
  && tar xzvf gmap-gsnap-${GSNAP_VERSION}.tar.gz \
  && cd gmap-${GSNAP_VERSION} \
  && ./configure --prefix=/usr/local --with-simd-level=sse42 \
  && make \
  && make check \
  && make install \
  && rm -rf /tmp/* \
  && apt remove --purge --yes \
    make \
    g++ \
    wget \
  && apt autoremove --purge --yes

RUN apt update && apt install -y wget build-essential zlib1g-dev libncurses5-dev libbz2-dev liblzma-dev libcurl4-openssl-dev; \
wget -q https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2; \
tar xjvf samtools-${SAMTOOLS_VERSION}.tar.bz2; \
cd /samtools-${SAMTOOLS_VERSION}/ && ./configure && make; \
mv /samtools-${SAMTOOLS_VERSION}/samtools /bin/; \
cd htslib-${HTSLIB_VERSION}/ && ./configure && make; \
mv htsfile libhts.so* tabix bgzip /bin; \
rm -rf /samtools*; \
apt clean build-essential zlib1g-dev wget && apt -y  autoclean && apt -y autoremove
