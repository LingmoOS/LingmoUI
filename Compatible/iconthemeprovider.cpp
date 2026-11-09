#include "iconthemeprovider.h"
#include <QFile>
#include <QIcon>

IconThemeProvider::IconThemeProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap)
{
}

QPixmap IconThemeProvider::requestPixmap(const QString& id, QSize* realSize,
    const QSize& requestedSize)
{
    // Sanitize requested size
    QSize size(requestedSize);
    if (size.width() < 1)
        size.setWidth(1);
    if (size.height() < 1)
        size.setHeight(1);

    // Return real size
    if (realSize)
        *realSize = size;

    // Absolute paths and resources are files; anything else is an icon name, even
    // when a file or folder with that name happens to sit in the working directory
    if (id.startsWith(QLatin1Char('/')) || id.startsWith(QLatin1String(":/")))
        return QPixmap(id).scaled(size);

    // Return icon from theme or fallback to a generic icon
    QIcon icon = QIcon::fromTheme(id);
    if (icon.isNull())
        icon = QIcon::fromTheme(QLatin1String("application-x-desktop"));

    return icon.pixmap(size);
}
