#!/bin/bash

# This script builds an AppImage for the Minetest client and server for Linux 64-bit.
# Run this script after cloning one or several Minetest Git folders with minetest_game.

# Place this script at the root of your Minetest Git clone.
# CC0 1.0 Universal

#
# Helper functions
#

# Copy some libraries needed by Minetest, but blacklisted by functions.sh
copy_socket() {
  mkdir -p usr/share/minetest/builtin/socket
  cp /usr/share/lua/5.1/socket.lua usr/share/minetest/builtin/
  cp /usr/share/lua/5.1/socket/*.lua usr/share/minetest/builtin/socket/
  cp /usr/lib/x86_64-linux-gnu/lua/5.1/socket/core.so usr/share/minetest/builtin/
  cp /usr/share/lua/5.1/ltn12.lua usr/share/minetest/builtin/socket
  cp /usr/share/lua/5.1/mime.lua usr/share/minetest/builtin/socket
  cp /usr/lib/x86_64-linux-gnu/liblua5.1-mime.so.2 usr/share/minetest/builtin/socket/mime.so
}

copy_more_libs() {
  cp /usr/lib/x86_64-linux-gnu/libkrb5.so.26 usr/lib/x86_64-linux-gnu/
  cp /usr/lib/x86_64-linux-gnu/libhcrypto.so.4 usr/lib/x86_64-linux-gnu/
  cp /usr/lib/x86_64-linux-gnu/libroken.so.18 usr/lib/x86_64-linux-gnu/
  cp /usr/lib/x86_64-linux-gnu/libwind.so.0 usr/lib/x86_64-linux-gnu/
  cp /usr/lib/x86_64-linux-gnu/libhx509.so.5 usr/lib/x86_64-linux-gnu/
  mkdir -p usr/lib/x86_64-linux-gnu/lua/5.1/socket
  # cp /usr/lib/x86_64-linux-gnu/lua/5.1/socket/core.so usr/lib/x86_64-linux-gnu/lua/5.1/socket
}

# Build Minetest
build_minetest() {
  cd "$HOME/minetest-at-school-linux/minetest/"
  git pull
  cd games/
  git clone https://github.com/minetest/minetest_game.git
  cd ../
  # Clean CMake cache
  rm CMakeCache.txt
  # Make it think it'll go to /usr to avoid runtime warnings...
  cmake . -DBUILD_CLIENT=1            \
          -DBUILD_SERVER=0            \
          -DENABLE_GETTEXT=1          \
          -DENABLE_LEVELDB=1          \
          -DENABLE_REDIS=1            \
          -DENABLE_FREETYPE=1         \
          -DCMAKE_BUILD_TYPE=Release  \
          -DCMAKE_INSTALL_PREFIX="/usr"
  make -j$(nproc)
  # ...but actually build into a local directory
  make DESTDIR="bin/Minetest.AppDir" install

  #
  # Minetest client AppImage
  #

  APP=Minetest

  cd bin/

  # Acquire and use the helper functions file
  wget -q https://github.com/probonopd/AppImages/raw/master/functions.sh -O ./functions.sh
  . ./functions.sh

  # Desktop file
  cd Minetest.AppDir/
  cp ../../misc/net.minetest.minetest.desktop minetest.desktop

  # Copy icon and remove unneeded files
  cd usr/share/
  cp icons/hicolor/128x128/apps/minetest.png ../../
  # rm -rf applications/ doc/ icons/ man/

  # Bundle required dependencies
  cd ../../
  copy_deps; copy_deps; copy_deps # Three runs to ensure we catch indirect ones
  delete_blacklisted
  move_lib
  copy_more_libs
  copy_socket

  # Final steps
  get_apprun
  cd ../
  generate_type2_appimage

  # Copy builds to an easily accessible location
  cd ../out/
  mkdir -p "$HOME/minetest-appimages/"
  for appimage in *.AppImage; do
    cp "$appimage" "$HOME/minetest-appimages/"
  done
}

# build_minetest master # Build Godot Git master
# build_minetest stable # Build a stable branch of Minetest Git
build_minetest
