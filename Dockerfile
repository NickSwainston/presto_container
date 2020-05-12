FROM kernsuite/base:4
RUN docker-apt-install \
    python3-pip \
    python3-numpy \
    python3-future \
    python3-six \
    python3-scipy \
    python3-astropy \
    gfortran \
    pgplot5 \
    libx11-dev \
    libglib2.0-dev \
    libcfitsio-dev \
    libpng-dev \
    libfftw3-dev \
    git
ADD . /code
ENV PRESTO /code
ENV LD_LIBRARY_PATH /code/lib
WORKDIR /code
RUN git clone https://github.com/scottransom/presto.git && \
    mv presto/* .
WORKDIR /code/src
RUN make libpresto slalib
#RUN make
WORKDIR /code
RUN pip3 install /code
RUN python3 tests/test_presto_python.py



#Then installs all the C scripts -----------------------------
WORKDIR /home
RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    python-pip \
    wget

RUN add-apt-repository -y ppa:kernsuite/kern-dev
RUN add-apt-repository -y -y multiverse

# upgrade the pip package to the latest version
RUN pip install --upgrade pip

WORKDIR /home/soft
RUN apt-get --no-install-recommends -y install \
    build-essential \
    autoconf \
    autotools-dev \
    automake \
    autogen \
    libtool \
    pkg-config \
    cmake \
    csh \
    gcc \
    gfortran \
    git \
    cvs \
    libcfitsio-dev \
    pgplot5 \
    #swig2.0 \
    hwloc \
    python-dev \
    libfftw3-3 \
    libfftw3-bin \
    libfftw3-dev \
    libfftw3-single3 \
    libx11-dev \
    #libpng12-dev \
    #libpng3 \
    libpnglite-dev \
    #libhdf5-10 \
    #libhdf5-cpp-11 \
    libhdf5-dev \
    libhdf5-serial-dev \
    libxml2 \
    libxml2-dev \
    libltdl-dev \
    gsl-bin \
    libgsl-dev 
    #libgsl2

# Installs the Kern suite components individually. Up to here, the Kern repository is only
# enbaled, not installed. So you have to specify the packages you want. There is a list here:
# https://launchpad.net/~kernsuite/+archive/ubuntu/kern-2
# Note that some packages need to be installed in a specfic order to work. Also, it doesn't seem
# that Kern doesn't set up environment variables for some tools.
RUN apt-get install -y psrcat
RUN apt-get install -y wget
#RUN apt-get install -y tempo
RUN git clone https://github.com/nanograv/tempo.git && \
    cd tempo && \
    ./prepare && \
    ./configure && \
    make && \
    make install
#ENV PATH $PATH:/home/soft/presto/bin
ENV TEMPO /home/soft/tempo
RUN apt-get install -y tempo2
RUN apt-get install -y sigproc
#RUN apt-get install -y presto python-presto
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get --no-install-recommends install -y presto
WORKDIR /code/src
RUN make makewisdom

ADD calc_nsub.py /usr/bin/
ADD ACCEL_sift.py /usr/bin/
