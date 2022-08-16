# Pull base image.
FROM ubuntu:22.04

# set docker label
LABEL Name=mint21xeddev Version=0.0.2

# set user and group with same UID/GID of the current user to avoid rights issues 
ARG UID
ARG GID
RUN grep -q ":$GID:" /etc/group || groupadd --gid $GID valagroup
RUN useradd --create-home --shell /bin/bash --uid $UID --gid $GID valauser

# Make sure APT operations are non-interactive
ENV DEBIAN_FRONTEND noninteractive

# Add basic tools
RUN apt-get update
RUN apt-get --yes upgrade
RUN apt-get --yes install wget gnupg locales unzip libfile-fcntllock-perl


# Set locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add files.
RUN echo "deb http://packages.linuxmint.com vanessa main upstream import backport \n\
    \n\
    deb http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse \n\
    deb http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse \n\
    deb http://archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse \n\
    \n\
    deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse" > /etc/apt/sources.list.d/official-package-repositories.list

RUN echo "deb-src http://packages.linuxmint.com vanessa main upstream import backport \n\
    \n\
    deb-src http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse \n\
    deb-src http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse \n\
    deb-src http://archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse \n\
    \n\
    deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse" > /etc/apt/sources.list.d/official-source-repositories.list

RUN echo "Package: * \n\
    Pin: origin live.linuxmint.com \n\
    Pin-Priority: 750 \n\
    \n\
    Package: * \n\
    Pin: release o=linuxmint,c=upstream \n\
    Pin-Priority: 700" > /etc/apt/preferences.d/official-package-repositories.pref

###################################
# Set up repositories
###################################

# Add linuxmint-keyring
RUN \
    wget http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/linuxmint-keyring_2016.05.26_all.deb > dev/null 2>&1 \
    && dpkg -i linuxmint-keyring_2016.05.26_all.deb \
    && rm linuxmint-keyring_2016.05.26_all.deb
RUN \
    wget http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/linuxmint-keyring_2022.06.21_all.deb > dev/null 2>&1 \
    && dpkg -i linuxmint-keyring_2022.06.21_all.deb \
    && rm linuxmint-keyring_2022.06.21_all.deb

# Empty default sources.list
RUN echo "" > /etc/apt/sources.list

# Update APT cache.
RUN apt-get update

################################### 
# Apply updates
###################################

RUN apt-get --yes dist-upgrade

###################################
# Install stuff
###################################

RUN apt-get --yes install \
    automake \
    build-essential \
    cmake \
    dh-make \
    fakeroot \
    libgee-0.8-dev \
    libgtk-3-dev \
    libgtksourceview-4-dev \
    libjson-glib-dev \
    libpeas-dev \
    libxapp-dev \
    meson \
    mint-themes \
    mint-y-icons \
    ninja-build \
    python3 \
    software-properties-common \
    valac \
    xed \
    xed-dev
