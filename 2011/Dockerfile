ARG HISTORIC_MIRROR=ftp://tug.org/historic/
ARG PERL_VERSION=5.14.4
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
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2011/texlive2011.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2011.iso \
    && rm texlive2011.iso

# install texlive in the installer directory
ADD texlive-2011.profile /installer/texlive-2011.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2011.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2011/ /usr/local/texlive/2011/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2011/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2011/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2011/bin/x86_64-linux:$PATH"