qt_standard_project_setup()

# Create Qt6 library target
qt_add_library(${TARGET} SHARED)

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
        Qt6::Core5Compat
        QHotkey::QHotkey
        )
target_include_directories(${TARGET} PRIVATE ${QHOTKEY_INCLUDE_DIR})

if (UNIX)
    if (NOT APPLE)
        target_link_libraries(${TARGET} PRIVATE Qt6::Gui Qt6::GuiPrivate)
        if (KF6WindowSystem_FOUND)
            target_link_libraries(${TARGET} PRIVATE KF6::WindowSystem)
        endif ()
    endif ()
endif ()

# Clear the list of source files
set(sources_files "")
set(qml_files "")
set(resource_files "")

#遍历所有Cpp文件
file(GLOB CPP_FILES *.cpp)
foreach (filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach (filepath)

#遍历所有h文件
file(GLOB H_FILES *.h)
foreach (filepath ${H_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach (filepath)

set(SINGLETON_FILES "Controls/LingmoRouter.qml" "Controls/LingmoUnits.qml")

#遍历所有qml文件
file(GLOB_RECURSE QML_PATHS Controls/*.qml Controls/*.qml qmldir)
foreach (filepath ${QML_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    if (${filename} MATCHES "qmldir")
        list(APPEND resource_files ${filename})
    else ()
        list(APPEND qml_files ${filename})
        # Check for singleton
        foreach (singletion_name ${SINGLETON_FILES})
            if (${filename} MATCHES ${singletion_name})
                set_source_files_properties(${filename} PROPERTIES QT_QML_SINGLETON_TYPE true)
            endif ()
        endforeach (singletion_name)
    endif ()
endforeach (filepath)

#遍历所有资源文件
set(RES_SUFFIX "")
set(RES_PATHS "")
list(APPEND RES_SUFFIX *.png *.jpg *.svg *.ico *.ttf *.webp *.js *.qm *.qsb)
list(APPEND RES_PATHS Controls Font Image)
foreach (respath ${RES_PATHS})
    foreach (filesuffix ${RES_SUFFIX})
        file(GLOB_RECURSE RES_FOUND ${respath}/${filesuffix})
        foreach (filepath ${RES_FOUND})
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
            list(APPEND resource_files ${filename})
        endforeach()
    endforeach ()
endforeach (respath)

# Set Qt6 QMl Plugins
qt_add_qml_module(${TARGET}
    PLUGIN_TARGET ${TARGET}
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/temp/${PROJECT_NAME}
    VERSION ${MODULE_VERSION_MAJOR}.${MODULE_VERSION_MINOR}
    URI ${PROJECT_NAME}
    TYPEINFO "plugins.qmltypes"
    SOURCES ${sources_files}
    QML_FILES ${qml_files}
    RESOURCES ${resource_files}
    RESOURCE_PREFIX "/lingmoui/kit"
)

# Translations, embedded where LingmoApp::init() looks for them
# (:/qt/qml/LingmoUI/i18n/lingmoui_<locale>.qm)
file(GLOB LINGMOUI_TS_FILES ${CMAKE_CURRENT_SOURCE_DIR}/../translations/lingmoui_*.ts)
qt_add_translation(LINGMOUI_QM_FILES ${LINGMOUI_TS_FILES})
qt_add_resources(${TARGET} "lingmoui_i18n"
    PREFIX "/qt/qml/LingmoUI/i18n"
    BASE ${CMAKE_CURRENT_BINARY_DIR}
    FILES ${LINGMOUI_QM_FILES}
)

set_target_properties(${TARGET}
    PROPERTIES  VERSION ${MODULE_VERSION} SOVERSION ${MODULE_VERSION_MAJOR})

add_subdirectory(GraphicalEffects)

install(DIRECTORY ${CMAKE_BINARY_DIR}/temp/${PROJECT_NAME} DESTINATION ${INSTALL_QMLDIR}
        PATTERN "lib${TARGET}.so*" EXCLUDE)
generate_export_header(${TARGET} BASE_NAME ${TARGET})

# The library is linked directly by apps (statusbar, filemanager...), so it must
# live in the linker path; the QML module dir only gets a symlink to it.
install(TARGETS ${TARGET} EXPORT ${TARGET}Targets DESTINATION ${CMAKE_INSTALL_LIBDIR})
file(RELATIVE_PATH _lingmoui_lib_rel "${INSTALL_QMLDIR}/${PROJECT_NAME}"
     "${CMAKE_INSTALL_FULL_LIBDIR}/lib${TARGET}.so.${MODULE_VERSION_MAJOR}")
install(CODE "file(CREATE_LINK \"${_lingmoui_lib_rel}\"
    \"\$ENV{DESTDIR}${INSTALL_QMLDIR}/${PROJECT_NAME}/lib${TARGET}.so\" SYMBOLIC)")

# Install Header
install(FILES ${H_FILES} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${TARGET})