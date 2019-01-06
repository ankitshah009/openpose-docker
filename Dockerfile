FROM nvidia/cuda:8.0-devel
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDNN_VERSION 5.1.10
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn5=$CUDNN_VERSION-1+cuda8.0

RUN apt-get --assume-yes install git
RUN apt-get --assume-yes install libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
RUN apt-get --assume-yes install --no-install-recommends libboost-all-dev
RUN apt-get --assume-yes install libgflags-dev libgoogle-glog-dev liblmdb-dev
RUN apt-get --assume-yes install python-pip
RUN pip install --upgrade numpy protobuf

RUN apt-get --assume-yes install libopencv-dev

RUN cd /home && git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose && cd openpose && mkdir build && cd build

RUN apt-get --assume-yes install wget
RUN CUDNN_URL="http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/cudnn-8.0-linux-x64-v5.1.tgz" && wget -c ${CUDNN_URL}
RUN tar -xzf cudnn-8.0-linux-x64-v5.1.tgz -C /usr/local
RUN rm cudnn-8.0-linux-x64-v5.1.tgz && ldconfig

RUN apt-get --assume-yes install cmake
RUN cd /home/openpose/build && cmake .. && make -j12
