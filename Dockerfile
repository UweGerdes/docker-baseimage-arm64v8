# base image for arm architecture (Raspberry Pi 3) with some essentials, and optional timezone and apt proxy cache (build arg)

FROM arm32v7/ubuntu
MAINTAINER entwicklung@uwegerdes.de

ARG APT_PROXY
ARG TZ=UTC

ENV DEBIAN_FRONTEND noninteractive
ENV TZ ${TZ}

RUN if [ -n "${APT_PROXY}" ] ; then \
		echo "Acquire::http { Proxy \"${APT_PROXY}\"; };" >> /etc/apt/apt.conf.d/01proxy ; \
		echo "Acquire::https { Proxy \"https://\"; };" >> /etc/apt/apt.conf.d/01proxy ; \
	fi && \
	echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends && \
	echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends && \
	apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y \
				bzip2 \
				ca-certificates \
				curl \
				git \
				gosu \
				net-tools \
				ssh \
				sudo \
				unzip \
				vim \
				wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

CMD [ "/bin/bash" ]

