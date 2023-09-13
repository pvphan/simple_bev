FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	ca-certificates \
	ffmpeg \
	git \
	libavcodec-dev \
	libavformat-dev \
	libjpeg-dev \
	libjpeg-dev \
	libomp-dev \
	libopenblas-dev \
	libopenmpi-dev \
	libpython3-dev \
	libsm6 \
	libswscale-dev \
	libxext6 \
	python-is-python3 \
	python3-pip \
	zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3 \
	&& pip install --upgrade pip \
	&& pip install \
		torch==1.12.0 \
		torchvision==0.13.0

WORKDIR /tmp
COPY requirements.txt .
RUN pip install -r ./requirements.txt
WORKDIR /simple_bev
