ARG HISTORIC_MIRROR=ftp://tug.org/historic/
ARG PERL_VERSION=5.32.1
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
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2020/texlive2020.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2020.iso \
    && rm texlive2020.iso

RUN cd /installer/; echo i | perl ./install-tl -repository /installer/; cat /usr/local/texlive/*/tlpkg/texlive.profile

# install texlive in the installer directory
ADD texlive-2020.profile /installer/texlive-2020.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2020.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2020/ /usr/local/texlive/2020/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2020/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2020/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2020/bin/x86_64-linux:$PATH"