# Base image
FROM nvidia/cuda:11.6.0-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory
WORKDIR /app

# Update package list and install required packages for GUI support
RUN apt-get update && \
    apt-get install -y \
    python3-dev python3-pip git libglib2.0-0 libsm6 libxext6 libxrender-dev x11-apps \
    make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
    liblzma-dev python-openssl git vim less \
    libfreetype6-dev libpng-dev libgl1 libglib2.0-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN pip3 install --upgrade pip
RUN pip3 install setuptools Cython

# Clone mmpose repository
RUN git clone https://github.com/open-mmlab/mmcv.git && \
    cd mmcv && \
    pip3 install -r requirements.txt && \
    MMCV_WITH_OPS=1 pip3 install -e .

# Clone mmpose repository
RUN git clone https://github.com/open-mmlab/mmpose.git

# Install mmpose and other requirements
RUN cd mmpose && pip3 install -r requirements/optional.txt && pip3 install -v -e .