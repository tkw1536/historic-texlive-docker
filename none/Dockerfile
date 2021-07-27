ARG PERL_VERSION=perl-5.34.0
FROM debian:buster as base

ARG PERL_VERSION
ENV HOME=/root \
    PERLBREW_ROOT=/usr/local/perlbrew
ENV PERLBREW_HOME=${HOME}/.perlbrew \
    PATH=${PERLBREW_ROOT}/bin:$PATH \
    PERLBREW_PATH=${PERLBREW_ROOT}/bin

ARG PERL_VERSION
RUN mkdir -p ${PERLBREW_ROOT} ${HOME} && \
    # install perlbrew deps
    apt-get update && \
    apt-get -y install \
        build-essential \
        wget \
        perl \
        && \
    apt-get clean && \
    # install perlbrew itself
    wget -qO- http://install.perlbrew.pl | bash && \
    # initalize perlbrew
    perlbrew init && \
    echo "source ${PERLBREW_ROOT}/etc/bashrc" >> /root/.bashrc && \
    # install perl, use it, and install cpanm
    perlbrew install --notest -v $PERL_VERSION && \
    perlbrew switch $PERL_VERSION && \
    perlbrew install-cpanm --notest


# properly set the environment variables
ARG PERL_VERSION
ENV PERLBREW_PATH=${PERLBREW_ROOT}/bin:${PERLBREW_ROOT}/perls/${PERL_VERSION}/bin \
    PERLBREW_MANPATH=${PERLBREW_ROOT}/bin:${PERLBREW_ROOT}/perls/${PERL_VERSION}/man
ENV PATH=${PERLBREW_PATH}:${PATH}
