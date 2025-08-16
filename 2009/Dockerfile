ARG HISTORIC_MIRROR=ftp://tug.org/historic/
ARG PERL_VERSION=5.10.1
FROM ghcr.io/tkw1536/texlive-docker:none-${PERL_VERSION} AS base

FROM base AS setup

# install setup dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        libarchive-tools \
        perl \
        wget

# Download the installer, and put all the files into /installer/
ARG HISTORIC_MIRROR
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2009/texlive2009.iso.xz \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2009.iso.xz \
    && rm texlive2009.iso.xz

# install texlive in the installer directory
ADD texlive-2009.profile /installer/texlive-2009.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2009.profile

# copy image for the final tag
FROM base AS final
COPY --from=setup /usr/local/texlive/2009/ /usr/local/texlive/2009/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2009/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2009/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2009/bin/x86_64-linux:$PATH"