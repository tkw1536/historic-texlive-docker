ARG HISTORIC_MIRROR=ftp://tug.org/historic/
ARG PERL_VERSION=5.26.3
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
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2017/texlive2017.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2017.iso \
    && rm texlive2017.iso

RUN cd /installer/; echo i | perl ./install-tl -repository /installer/; cat /usr/local/texlive/*/tlpkg/texlive.profile

# install texlive in the installer directory
ADD texlive-2017.profile /installer/texlive-2017.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2017.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2017/ /usr/local/texlive/2017/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2017/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2017/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2017/bin/x86_64-linux:$PATH"