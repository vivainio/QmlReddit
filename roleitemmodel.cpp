#include "roleitemmodel.h"

RoleItemModel::RoleItemModel(const QHash<int, QByteArray> &roleNames)
{
    setRoleNames(roleNames);
}

QVariantMap RoleItemModel::getModelData(const QAbstractItemModel* mdl, int row)
{
    QHash<int,QByteArray> names = mdl->roleNames();
    QHashIterator<int, QByteArray> i(names);
    QVariantMap res;
     while (i.hasNext()) {
        i.next();
        QModelIndex idx = mdl->index(row, 0);
        QVariant data = idx.data(i.key());
        res[i.value()] = data;
         //cout << i.key() << ": " << i.value() << endl;
     }
     return res;
}


