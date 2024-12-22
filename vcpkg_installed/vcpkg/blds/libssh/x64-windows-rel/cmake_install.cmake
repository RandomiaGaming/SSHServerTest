# Install script for directory: D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/pkgs/libssh_x64-windows")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
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

if(CMAKE_INSTALL_COMPONENT STREQUAL "pkgconfig" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/libssh.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/libssh" TYPE FILE FILES "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/libssh-config-version.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/doc/cmake_install.cmake")
  include("D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/include/cmake_install.cmake")
  include("D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/src/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
