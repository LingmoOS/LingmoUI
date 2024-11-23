cmake_minimum_required(VERSION 3.20)

project(example VERSION 1.0)

#配置通用编译
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#导入Qt相关依赖包
find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core Widgets Svg Quick QuickControls2 DBus Core5Compat)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Widgets Svg Quick QuickControls2 DBus Core5Compat)

# Clear the list of source files
set(sources_files "")
set(qml_files "")
set(resource_files "")

#遍历所有Cpp文件
file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach (filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach (filepath)

#遍历所有qml文件
file(GLOB_RECURSE QML_PATHS qml/*.qml qmldir)
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
file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp *.js *.qm)
foreach (filepath ${RES_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND resource_files ${filename})
endforeach (filepath)

message(STATUS "LINGMOUI_TEMP_IMPORT_PATH: ${LINGMOUI_TEMP_IMPORT_PATH}")
add_compile_definitions(LINGMOUI_TEMP_IMPORT_PATH="${LINGMOUI_TEMP_IMPORT_PATH}")

qt_add_executable(${PROJECT_NAME}
    MANUAL_FINALIZATION
    ${sources_files}
)

qt_add_resources(${PROJECT_NAME} "resources"
    PREFIX "/"
    FILES ${resource_files} ${qml_files}
)

#目标文件链接库
target_link_libraries(${PROJECT_NAME} PRIVATE
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Svg
        Qt${QT_VERSION_MAJOR}::Network
        ${TARGET}
)

qt_finalize_executable(${PROJECT_NAME})
