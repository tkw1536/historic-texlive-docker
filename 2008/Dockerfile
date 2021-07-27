ARG HISTORIC_MIRROR=ftp://tug.org/historic/
ARG PERL_VERSION=5.10.1
FROM ghcr.io/tkw1536/texlive-docker:none-${PERL_VERSION} as base

FROM base as setup

# install setup dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        bsdtar

# Download the installer, and put all the files into /installer/
ARG HISTORIC_MIRROR
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2008/texlive2008.iso.lzma \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2008.iso.lzma \
    && rm texlive2008.iso.lzma

# install texlive in the installer directory
ADD texlive-2008.profile /installer/texlive-2008.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2008.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2008/ /usr/local/texlive/2008/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2008/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2008/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2008/bin/x86_64-linux:$PATH"