FROM python:3.6.5
RUN chown root:root /tmp
ENV LANG C.UTF-8

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-get update -y

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y --no-install-recommends build-essential apt-utils ca-certificates wget vim git cmake

RUN apt-get install -y --no-install-recommends software-properties-common

RUN apt-get update -y

RUN wget https://bootstrap.pypa.io/pip/3.6/get-pip.py

RUN python3 get-pip.py && rm get-pip.py


# ==================================================================
# opencv
# ------------------------------------------------------------------
RUN apt-get install -y --no-install-recommends libatlas-base-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libhdf5-serial-dev \
    libleveldb-dev \
    liblmdb-dev \
    libprotobuf-dev \
    libsnappy-dev \
    protobuf-compiler \
    libgtk2.0-dev \
    pkg-config

RUN apt-get remove -y python2.7

RUN pip3 install numpy scipy matplotlib

RUN git clone --branch 4.0.1 https://github.com/opencv/opencv ~/opencv

RUN git clone https://github.com/opencv/opencv_contrib.git ~/opencv_contrib

RUN mkdir -p ~/opencv/build && cd ~/opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D WITH_IPP=OFF \
          -D WITH_CUDA=OFF \
          -D WITH_OPENCL=OFF \
          -D BUILD_TESTS=OFF \
          -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
          -D BUILD_PERF_TESTS=OFF \
          -D OPENCV_ENABLE_NONFREE=ON \
          -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
          .. && \
     make -j"$(nproc)" install 
#     && ln -s /usr/local/include/opencv4/opencv2 /usr/local/include/opencv2

#RUN find ~/opencv -name "cv2.cpython-3*m-x86_64-linux-gnu.so"

#RUN ls /usr/lib/python3/dist-packages

#RUN git clone https://github.com/bachnx23/watermark-remover.git /root/watermark-remover

#RUN pip install coloredlogs

#WORKDIR /root/watermark-remover

