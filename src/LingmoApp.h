#ifndef LINGMOAPP_H
#define LINGMOAPP_H

#include <QObject>
#include <QQmlEngine>
#include <QTranslator>

#include "singleton.h"
#include "stdafx.h"

/**
 * @brief The LingmoApp class. Used in all apps.
 */
class LingmoApp : public QObject {
  Q_OBJECT
  QML_SINGLETON
  QML_NAMED_ELEMENT(LingmoApp)

  Q_PROPERTY_AUTO(QLocale, locale)
  Q_PROPERTY_AUTO_P(QObject *, launcher)

 private:
  explicit LingmoApp(QObject *parent = nullptr);

  ~LingmoApp() override = default;

 public:
  SINGLETON(LingmoApp)

  static LingmoApp *create(QQmlEngine *, QJSEngine *) { return getInstance(); }

  Q_INVOKABLE void init(QObject *launcher, QLocale locale = QLocale::system());

 private:
  QQmlEngine *_engine{};
  QTranslator *_translator = nullptr;
};

#endif  // LINGMOAPP_H
