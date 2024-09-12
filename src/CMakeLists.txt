# Create Qt6 library target
qt_add_library(${TARGET} SHARED)

list(APPEND ${TARGET_SOURCES}  
        iconthemeprovider.cpp
        thememanager.cpp

        newiconitem.cpp
        managedtexturenode.cpp
        wheelhandler.cpp
        qqmlsortfilterproxymodel.cpp

        desktop/menupopupwindow.cpp

        # lingmoui.qrc
        # lingmo-style/style.qrc
        )
if (MSVC)
    list(APPEND ${TARGET_SOURCES} 
            platforms/windows/windowhelper.cpp platforms/windows/windowhelper.h
            platforms/windows/blurhelper/windowblur.cpp platforms/windows/blurhelper/windowblur.h
            platforms/windows/shadowhelper/boxshadowrenderer.cpp platforms/windows/shadowhelper/boxshadowrenderer.h
            platforms/windows/shadowhelper/tileset.cpp platforms/windows/shadowhelper/tileset.h
            platforms/windows/shadowhelper/windowshadow.cpp platforms/windows/shadowhelper/windowshadow.h
            )
    target_include_directories(${TARGET} PRIVATE platforms/windows)
elseif (APPLE)
    list(APPEND ${TARGET_SOURCES} 
            platforms/mac/windowhelper.cpp platforms/mac/windowhelper.h
            platforms/mac/blurhelper/windowblur.cpp platforms/mac/blurhelper/windowblur.h
            platforms/mac/shadowhelper/boxshadowrenderer.cpp platforms/mac/shadowhelper/boxshadowrenderer.h
            platforms/mac/shadowhelper/tileset.cpp platforms/mac/shadowhelper/tileset.h
            platforms/mac/shadowhelper/windowshadow.cpp platforms/mac/shadowhelper/windowshadow.h
            )
    target_include_directories(${TARGET} PRIVATE platforms/mac)
else ()
    list(APPEND ${TARGET_SOURCES} 
            platforms/linux/windowhelper.cpp platforms/linux/windowhelper.h
            platforms/linux/blurhelper/windowblur.cpp platforms/linux/blurhelper/windowblur.h
            platforms/linux/shadowhelper/boxshadowrenderer.cpp platforms/linux/shadowhelper/boxshadowrenderer.h
            platforms/linux/shadowhelper/tileset.cpp platforms/linux/shadowhelper/tileset.h
            platforms/linux/shadowhelper/windowshadow.cpp platforms/linux/shadowhelper/windowshadow.h
            )
    target_include_directories(${TARGET} PRIVATE platforms/linux)
endif ()

target_link_libraries(${TARGET}
        PUBLIC
        Qt6::Core
        Qt6::Gui
        Qt6::DBus
        Qt6::Widgets
        PRIVATE
        Qt6::Qml
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::GuiPrivate
        )

if (UNIX)
    if (NOT APPLE)
        target_link_libraries(${TARGET} PRIVATE Qt6::Gui Qt6::GuiPrivate KF6::WindowSystem)
    endif ()
endif ()

#遍历所有qml文件
file(GLOB_RECURSE QML_PATHS controls/*.qml qmldir)
foreach (filepath ${QML_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    if (${filename} MATCHES "qmldir")
        list(APPEND resource_files ${filename})
    else ()
        list(APPEND qml_files ${filename})
    endif ()
endforeach (filepath)

#遍历所有资源文件
file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp *.js *.qm)
foreach (filepath ${RES_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND resource_files ${filename})
endforeach (filepath)

# Set Qt6 QMl Plugins
qt_add_qml_module(${TARGET}
    PLUGIN_TARGET ${TARGET}
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/temp/${PROJECT_NAME}
    VERSION ${MODULE_VERSION_MAJOR}.${MODULE_VERSION_MINOR}
    URI ${PROJECT_NAME}
    TYPEINFO "plugins.qmltypes"
    SOURCES ${TARGET_SOURCES} 
    QML_FILES ${qml_files}
    RESOURCES ${resource_files}
    RESOURCE_PREFIX "/lingmoui/kit"
)

set_target_properties(${TARGET} PROPERTIES  VERSION ${MODULE_VERSION} SOVERSION ${MODULE_VERSION_MAJOR})

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/temp/${PROJECT_NAME} DESTINATION ${INSTALL_QMLDIR})
generate_export_header(${TARGET} BASE_NAME ${TARGET})
install(TARGETS ${TARGET} EXPORT ${TARGET}Targets ${INSTALL_TARGETS_DEFAULT_ARGS})
install(TARGETS ${TARGET} DESTINATION ${INSTALL_QMLDIR}/${PROJECT_NAME})

# Install Controls
# install(DIRECTORY controls/ DESTINATION ${INSTALL_QMLDIR}/${PROJECT_NAME})

# INSTALL STYLE
install(DIRECTORY lingmo-style DESTINATION ${INSTALL_QMLDIR}/QtQuick/Controls)
