FROM debian
MAINTAINER Marco Guerri

RUN useradd -m swtpm

RUN apt-get update
RUN apt-get install -y \
        git \
        gcc \
        libtool \
        libssl-dev \
        openssl \
        libtasn1-6 \
        libtasn1-6-dev \
        libseccomp-dev \
        make \
        autoconf \
        automake \
        socat \
        pkg-config \
        m4 \
        autoconf-archive \
        libjson-c-dev \
        libcurl4-openssl-dev \
        libjson-glib-dev \
        expect \
        gawk \
        sudo

RUN echo "swtpm ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN ln -s /usr/sbin/useradd /usr/bin/useradd
RUN ln -s /usr/sbin/groupadd /usr/bin/groupadd

USER swtpm

WORKDIR /home/swtpm

RUN git clone https://github.com/stefanberger/libtpms && \
    cd libtpms && \
    ./bootstrap.sh && \
    ./configure --prefix=/usr && \
    make && \
    sudo make install


RUN git clone https://github.com/stefanberger/swtpm && \
    cd swtpm && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    sudo make install

RUN ls
COPY init.sh /home/swtpm/init.sh
RUN sudo chmod a+x /home/swtpm/init.sh

ENTRYPOINT /home/swtpm/init.sh
