/**
 *  @brief This file contains commonly used types, etc.
 *         for LingmoUI
 */
#ifndef LINGMODEFINES_H
#define LINGMODEFINES_H

#include <QObject>
#include <QQmlEngine>

/**
 * @brief LingmoWindowType
 */
namespace LingmoWindowType {
Q_NAMESPACE

enum LaunchMode {
    Standard = 0,
    SingleTask = 1,
    SingleInstance = 2
};
Q_ENUM_NS(LaunchMode)

QML_NAMED_ELEMENT(LingmoWindowType)
}

namespace LingmoThemeType {
Q_NAMESPACE
enum DarkMode {
    System = 0x0000,
    Light = 0x0001,
    Dark = 0x0002,
};

Q_ENUM_NS(DarkMode)

QML_NAMED_ELEMENT(LingmoThemeType)
}

// Used in LingmoCustomDialog
namespace LingmoCustomDialogType {
Q_NAMESPACE
enum ButtonFlag { NeutralButton = 0x0001,
    NegativeButton = 0x0002,
    PositiveButton = 0x0004 };

Q_ENUM_NS(ButtonFlag)

QML_NAMED_ELEMENT(LingmoCustomDialogType)
}

#endif // LINGMODEFINES_H
