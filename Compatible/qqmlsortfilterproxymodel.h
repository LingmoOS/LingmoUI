/****************************************************************************
 * Copyright (C) 2018 Pierre-Yves Siret
 *
 * $BEGIN_LICENSE:MIT$
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * $END_LICENSE$
 ***************************************************************************/

#ifndef QQMLSORTFILTERPROXYMODEL_H
#define QQMLSORTFILTERPROXYMODEL_H

#include <QQmlEngine>
#include <QQmlExpression>
#include <QSortFilterProxyModel>

#include <QRegularExpression>
#include <qqmlintegration.h>

class QQmlSortFilterProxyModel : public QSortFilterProxyModel {
    Q_OBJECT
    QML_NAMED_ELEMENT(SortFilterProxyModel)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString filterRoleName READ filterRoleName WRITE setFilterRoleName NOTIFY filterRoleNameChanged)
    Q_PROPERTY(
        QString filterPattern READ filterPattern WRITE setFilterPattern NOTIFY filterPatternChanged)
    Q_PROPERTY(QVariant filterValue READ filterValue WRITE setFilterValue NOTIFY filterValueChanged)
    Q_PROPERTY(QQmlScriptString filterExpression READ filterExpression WRITE setFilterExpression
            NOTIFY filterExpressionChanged)

    Q_PROPERTY(
        QString sortRoleName READ sortRoleName WRITE setSortRoleName NOTIFY sortRoleNameChanged)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder NOTIFY sortOrderChanged)
    Q_PROPERTY(QQmlScriptString sortExpression READ sortExpression WRITE setSortExpression NOTIFY sortExpressionChanged)

public:
    QQmlSortFilterProxyModel(QObject* parent = 0);

    int count() const;

    QHash<int, QByteArray> roleNames() const override;

    const QString& filterRoleName() const;
    void setFilterRoleName(const QString& filterRoleName);

    QString filterPattern() const;
    void setFilterPattern(const QString& filterPattern);

    const QVariant& filterValue() const;
    void setFilterValue(const QVariant& filterValue);

    const QQmlScriptString& filterExpression() const;
    void setFilterExpression(const QQmlScriptString& filterScriptString);

    const QString& sortRoleName() const;
    void setSortRoleName(const QString& sortRoleName);

    void setSortOrder(Qt::SortOrder sortOrder);

    const QQmlScriptString& sortExpression() const;
    void setSortExpression(const QQmlScriptString& compareScriptString);

signals:
    void countChanged();

    void filterRoleNameChanged();
    void filterPatternChanged();
    void filterValueChanged();
    void filterExpressionChanged();

    void sortRoleNameChanged();
    void sortOrderChanged();
    void sortExpressionChanged();

protected:
    bool filterAcceptsRow(int source_row, const QModelIndex& source_parent) const override;
    bool lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const override;

private slots:
    void invalidateFilter();
    void updateFilterRole();
    void updateSortRole();
    void updateRoles();

private:
    QVariantMap modelDataMap(const QModelIndex& modelIndex) const;

    QString m_filterRoleName;
    QString m_sortRoleName;

    QQmlScriptString m_filterScriptString;
    QQmlExpression* m_filterExpression;

    QQmlScriptString m_compareScriptString;
    QQmlExpression* m_compareExpression;
    QVariant m_filterValue;

    QRegularExpression m_regExp;
    Qt::CaseSensitivity m_caseSensitivity;
};

#endif // QQMLSORTFILTERPROXYMODEL_H
