#pragma once

#include <QJSEngine>

/**
 * @brief The Singleton class
 *
 * One instance per process, shared by every QML engine. QML takes ownership
 * of a singleton returned from a static create() unless told otherwise, so
 * the first engine to be destroyed would delete it and leave the next engine
 * with a dangling pointer: the instance is marked as owned by C++.
 */
template <typename T>
class Singleton {
public:
    static T* getInstance();
};

template <typename T>
T* Singleton<T>::getInstance()
{
    static T* instance = [] {
        T* object = new T();
        QJSEngine::setObjectOwnership(object, QJSEngine::CppOwnership);
        return object;
    }();
    return instance;
}

#define SINGLETON(Class)                        \
private:                                        \
    friend class Singleton<Class>;              \
                                                \
public:                                         \
    static Class* getInstance()                 \
    {                                           \
        return Singleton<Class>::getInstance(); \
    }
