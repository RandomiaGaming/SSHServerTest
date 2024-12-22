# Install script for directory: D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/src/libssh-0-5594e2099c.clean/src

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

if(CMAKE_INSTALL_COMPONENT STREQUAL "libraries" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY OPTIONAL FILES "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/src/ssh.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE SHARED_LIBRARY FILES "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/src/ssh.dll")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/libssh/libssh-config.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/libssh/libssh-config.cmake"
         "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/src/CMakeFiles/Export/35adb0cb40569b434abcb13fe0a6f11a/libssh-config.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/libssh/libssh-config-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/libssh/libssh-config.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/libssh" TYPE FILE FILES "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/src/CMakeFiles/Export/35adb0cb40569b434abcb13fe0a6f11a/libssh-config.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/libssh" TYPE FILE FILES "D:/ImportantData/Coding/EpsilonTheatrics/SSHServerTest/vcpkg_installed/vcpkg/blds/libssh/x64-windows-rel/src/CMakeFiles/Export/35adb0cb40569b434abcb13fe0a6f11a/libssh-config-release.cmake")
  endif()
endif()
