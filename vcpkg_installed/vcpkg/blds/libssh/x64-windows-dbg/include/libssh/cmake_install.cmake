# Install script for directory: D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/include/libssh

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/pkgs/libssh_x64-windows/debug")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "OFF")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/libssh" TYPE FILE FILES
    "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/include/libssh/callbacks.h"
    "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/include/libssh/libssh.h"
    "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/include/libssh/ssh2.h"
    "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/include/libssh/legacy.h"
    "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/include/libssh/libsshpp.hpp"
    "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/include/libssh/sftp.h"
    "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/include/libssh/server.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/libssh" TYPE FILE FILES "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-dbg/include/libssh/libssh_version.h")
endif()

