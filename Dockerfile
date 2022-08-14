FROM ubuntu:latest
ARG UID
ARG GID
LABEL Name=valagtk4 Version=0.0.1
RUN grep -q ":$GID:" /etc/group || groupadd --gid $GID valagroup
RUN useradd --create-home --shell /bin/bash --uid $UID --gid $GID valauser
RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN apt-get -y install build-essential
RUN add-apt-repository -y ppa:vala-team
RUN apt-get -y update && apt-get -y install valac
RUN apt-get -y install libgtk-4-bin libgtk-4-common libgtk-4-dev libgtk-4-doc
RUN apt-get -y install meson ninja-build cmake gettext desktop-file-utils appstream-util
RUN apt-get -y install flatpak flatpak-builder
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
RUN flatpak install -y flathub org.gnome.Platform//42
RUN flatpak install -y flathub org.gnome.Sdk//42 
