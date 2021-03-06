# Directories to look for dependencies
set(DIRS "${CMAKE_BINARY_DIR}")

# Path used for searching by FIND_XXX(), with appropriate suffixes added
if(CMAKE_PREFIX_PATH)
    foreach(dir ${CMAKE_PREFIX_PATH})
        list(APPEND DIRS "${dir}/bin" "${dir}/lib")
    endforeach()
endif()

# Append Qt's lib folder which is two levels above Qt5Widgets_DIR
list(APPEND DIRS "${Qt5Widgets_DIR}/../..")
list(APPEND DIRS "/usr/local/lib")
list(APPEND DIRS "/usr/lib")

include(InstallRequiredSystemLibraries)

message(STATUS "APPS: ${APPS}")
message(STATUS "QT_PLUGINS: ${QT_PLUGINS}")
message(STATUS "DIRS: ${DIRS}")

install(CODE "include(BundleUtilities)
      fixup_bundle(\"${APPS}\" \"${QT_PLUGINS}\" \"${DIRS}\")")

# Packaging
set(CPACK_PACKAGE_VENDOR "Qv2ray Development Group")
set(CPACK_PACKAGE_VERSION ${QV2RAY_VERSION_STRING})
set(CPACK_PACKAGE_DESCRIPTION "Cross-platform V2Ray Client written in Qt.")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/Qv2ray/Qv2ray")
set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/assets/icons/qv2ray.ico")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE")

if(BUILD_NSIS)
    add_definitions(-DQV2RAY_NO_ASIDECONFIG)
    if(MSVC)
        set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/assets/icons\\\\qv2ray.ico")
        set(CPACK_GENERATOR "NSIS")
        set(CPACK_NSIS_MUI_ICON "${CMAKE_SOURCE_DIR}/assets/icons/qv2ray.ico")
        set(CPACK_NSIS_MUI_UNIICON "${CMAKE_SOURCE_DIR}/assets/icons/qv2ray.ico")
        set(CPACK_NSIS_DISPLAY_NAME "Qv2ray")
        set(CPACK_NSIS_PACKAGE_NAME "Qv2ray")
        set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
            CreateShortCut \\\"$DESKTOP\\\\Qv2ray.lnk\\\" \\\"$INSTDIR\\\\qv2ray.exe\\\"
            CreateDirectory \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Qv2ray\\\"
            CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Qv2ray\\\\Qv2ray.lnk\\\" \\\"$INSTDIR\\\\qv2ray.exe\\\"
            WriteRegStr HKLM \\\"Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Uninstall\\\\qv2ray\\\" \\\"DisplayIcon\\\" \\\"$INSTDIR\\\\qv2ray.exe\\\"
            WriteRegStr HKLM \\\"Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Uninstall\\\\qv2ray\\\" \\\"HelpLink\\\" \\\"https://qv2ray.github.io\\\"
            WriteRegStr HKLM \\\"Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Uninstall\\\\qv2ray\\\" \\\"InstallLocation\\\" \\\"$INSTDIR\\\"
            WriteRegStr HKLM \\\"Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Uninstall\\\\qv2ray\\\" \\\"URLUpdateInfo\\\" \\\"https://github.com/Qv2ray/Qv2ray/releases\\\"
            WriteRegStr HKLM \\\"Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Uninstall\\\\qv2ray\\\" \\\"URLInfoAbout\\\" \\\"https://github.com/Qv2ray/Qv2ray\\\"
        ")
        set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
            Delete \\\"$DESKTOP\\\\Qv2ray.lnk\\\"
            Delete \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Qv2ray\\\\Qv2ray.lnk\\\"
            RMDir \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Qv2ray\\\"
            DeleteRegKey HKLM \\\"Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Uninstall\\\\qv2ray\\\"
        ")
        set(CPACK_PACKAGE_INSTALL_DIRECTORY "qv2ray")
    endif()
endif()

if(APPLE)
    set(CPACK_GENERATOR "DragNDrop")
endif()

include(CPack)
