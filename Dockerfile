FROM openshift/base-centos7

MAINTAINER Virendrab <virendra@test.com>

ENV \ 
    HOME=/opt/app-root/src

# Set the labels that are used for Openshift to describe the builder image.
LABEL 
    io.openshift.tags="builder" \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
    io.openshift.s2i.destination="/opt/app-root"

#Update centos 
RUN yum update -y

#Install Dependencies
RUN yum groupinstall 'Development Tools' -y
RUN yum install -y epel-release
RUN yum install -y \
        curl \
        freetype-devel \
        libpng12-devel \
        pkgconfig \
        python \
        python-devel \
        rsync \
        unzip \
        nss_wrapper \
        gettext \
        python-pip \
        atlas \
        atlas-devel \
        gcc-gfortran \
        openssl-devel \ 
        libffi-devel \
        && \
        yum clean all -y

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        pandas \
        pymisp \
        requests \
        Pillow \
        && \
python -m ipykernel.kernelspec

# --- DO NOT EDIT OR DELETE BETWEEN THE LINES --- #
# These lines will be edited automatically by parameterized_docker_build.sh. #
# COPY _PIP_FILE_ /
# RUN pip --no-cache-dir install /_PIP_FILE_
# RUN rm -f /_PIP_FILE_

# Install TensorFlow CPU version from central repo
COPY  ["s2i/run", "s2i/assemble", "s2i/save-artifacts", "s2i/usage", "/usr/libexec/s2i/"]

USER 1001

WORKDIR $HOME

CMD ["/usr/libexec/s2i/usage"]
