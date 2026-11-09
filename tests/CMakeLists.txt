find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Test)

# Creates and destroys QML engines that import LingmoUI.CompatibleModule in the
# same process (apps that open a QQuickView per window do this).
add_executable(tst_enginerecreation tst_enginerecreation.cpp)
target_link_libraries(tst_enginerecreation PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::Test)
add_test(NAME tst_enginerecreation COMMAND tst_enginerecreation)
set_tests_properties(tst_enginerecreation PROPERTIES
    ENVIRONMENT "QML_IMPORT_PATH=${LINGMOUI_TEMP_IMPORT_PATH};QT_QPA_PLATFORM=offscreen")
