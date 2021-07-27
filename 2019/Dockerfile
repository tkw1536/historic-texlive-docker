ARG HISTORIC_MIRROR=ftp://tug.org/historic/
ARG PERL_VERSION=5.30.3
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
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2019/texlive2019.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2019.iso \
    && rm texlive2019.iso

RUN cd /installer/; echo i | perl ./install-tl -repository /installer/; cat /usr/local/texlive/*/tlpkg/texlive.profile

# install texlive in the installer directory
ADD texlive-2019.profile /installer/texlive-2019.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2019.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2019/ /usr/local/texlive/2019/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2019/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2019/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2019/bin/x86_64-linux:$PATH"