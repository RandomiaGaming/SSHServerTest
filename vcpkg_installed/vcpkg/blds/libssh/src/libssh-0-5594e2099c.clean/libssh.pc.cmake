prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}
libdir=@CMAKE_INSTALL_FULL_LIBDIR@
includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@

Name: @PROJECT_NAME@
Description: The SSH Library
Version: @PROJECT_VERSION@
Libs: -L${libdir} -lssh
Libs.private: @PC_LIBS_PRIVATE@
Requires.private: @PC_REQUIRES_PRIVATE@
Cflags: -I${includedir}
