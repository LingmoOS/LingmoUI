cmake_minimum_required(VERSION 3.5)

set(PROJECT_NAME LingmoUI)
set(MODULE_VERSION_MAJOR 3)
set(MODULE_VERSION_MINOR 0)
set(MODULE_VERSION_PATCH 0)
set(MODULE_VERSION ${MODULE_VERSION_MAJOR}.${MODULE_VERSION_MINOR}.${MODULE_VERSION_PATCH})
set(TARGET ${PROJECT_NAME}${MODULE_VERSION_MAJOR})

project(${PROJECT_NAME} VERSION ${MODULE_VERSION})


set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#DEFAULT COMPONENTS DEFINITIONS
option(COMPONENT_EDITOR "Build editor component" ON)
option(COMPONENT_FM "Build filemanager component" ON)
option(COMPONENT_ACCOUNTS "Build accounts component" ON)
option(COMPONENT_TERMINAL "Build terminal component" ON)
option(COMPONENT_STORE "Build store component" OFF)
option(COMPONENT_TAGGING "Build tagging component" ON)
option(COMPONENT_SYNCING "Build syncing component" ON)

find_package(ECM REQUIRED NO_MODULE)
list(APPEND CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})
message(STATUS "ECM version: ${ECM_VERSION}")

set(QT Core Widgets Quick QuickControls2 DBus)
find_package(Qt6 REQUIRED ${QT})
if (UNIX)
    if (NOT APPLE)
        list(APPEND QT GuiPrivate)
        find_package(KF6WindowSystem REQUIRED)
    endif ()
endif ()

include(GenerateExportHeader)
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(ECMGenerateHeaders)

# Get the installation directory from qmake
if(ECM_VERSION VERSION_LESS 5.93.0)
    include(ECMQueryQmake)
    query_qmake(INSTALL_QMLDIR QT_INSTALL_QML)
else()
    include(ECMQueryQt)
    ecm_query_qt(INSTALL_QMLDIR QT_INSTALL_QML)
endif()

if (INSTALL_QMLDIR)
    message(STATUS "QML directory:" "${INSTALL_QMLDIR}")
else ()
    message(FATAL_ERROR "QML directory cannot be detected.")
endif ()

# Install
if (MSVC)
    # Install LingmoUI to vcpkg installed dir
    # for example.
    # _VCPKG_INSTALLED_DIR:PATH=C:/app/vcpkg/installed
    # VCPKG_TARGET_TRIPLET:STRING=x64-windows
    # The final installed dir is C:/app/vcpkg/installed/x64-windows/share/LingmoUI
    set(CMAKECONFIG_INSTALL_DIR "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/share/${TARGET}")
    set(CMAKE_INSTALL_PREFIX "${_VCPKG_INSTALLED_DIR}")
else ()
    set(CMAKECONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${TARGET}")
endif ()
message(STATUS "CMake Config install directory:" "${CMAKECONFIG_INSTALL_DIR}")

# Qt Widgets Style
#if (UNIX)
#    find_package(ECM REQUIRED NO_MODULE)
#    set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
#    include(ECMQueryQmake)
#    query_qmake(CMAKE_INSTALL_QTPLUGINDIR QT_INSTALL_PLUGINS)
#    add_subdirectory(qtwidgets-style)
#endif ()

add_subdirectory(src)

configure_package_config_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/LingmoUIConfig.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${TARGET}Config.cmake"
        INSTALL_DESTINATION
        "${CMAKECONFIG_INSTALL_DIR}"
        PATH_VARS
        CMAKECONFIG_INSTALL_DIR CMAKE_INSTALL_PREFIX
)

write_basic_package_version_file(
        ${CMAKE_CURRENT_BINARY_DIR}/${TARGET}ConfigVersion.cmake
        VERSION ${MODULE_VERSION}
        COMPATIBILITY AnyNewerVersion
)
if(NOT APPLE)
install(
        FILES
        "${CMAKE_CURRENT_BINARY_DIR}/${TARGET}Config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/${TARGET}ConfigVersion.cmake"
        DESTINATION
        "${CMAKECONFIG_INSTALL_DIR}"
        COMPONENT
        Devel
)
install(FILES conf/version DESTINATION /etc/${TARGET}/ COMPONENT Runtime)

# install(FILES src/Windows.tar.xz DESTINATION ~/.update/ COMPONENT Runtime)

install(EXPORT ${TARGET}Targets
        DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
        FILE LingmoUITargets.cmake
        )
endif()
