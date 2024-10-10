/**
 *  @brief This file contains commonly used types, etc.
 *         for LingmoUI
 */
#ifndef LINGMODEFINES_H
#define LINGMODEFINES_H

#include <QObject>
#include <QQmlEngine>

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

#endif // LINGMODEFINES_H
