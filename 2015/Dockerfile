ARG HISTORIC_MIRROR=ftp://tug.org/historic/
ARG PERL_VERSION=5.22.4
FROM ghcr.io/tkw1536/texlive-docker:none-${PERL_VERSION} as base

FROM base as setup

# install setup dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        bsdtar \
        perl \
        wget

# Download the installer, and put all the files into /installer/
ARG HISTORIC_MIRROR
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2015/texlive2015.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2015.iso \
    && rm texlive2015.iso

# install texlive in the installer directory
ADD texlive-2015.profile /installer/texlive-2015.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2015.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2015/ /usr/local/texlive/2015/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2015/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2015/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2015/bin/x86_64-linux:$PATH"