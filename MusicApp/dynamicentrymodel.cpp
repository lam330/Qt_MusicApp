#include "dynamicentrymodel.h"
#include <QString>
#include <QFileInfo>
#include <QUrl>

DynamicEntryModel::DynamicEntryModel(QObject *parent)
    : QAbstractListModel(parent)
{
    m_roleNames[FileUrlRole] = "fileUrl";
    m_roleNames[FileNameRole] = "fileName";
    pathFolder = "C:/Users/ADMIN/Desktop/lamle/MusicApp/MusicApp/music";

    pathData(pathFolder);
    nameFileData(pathFolder);

}

DynamicEntryModel::~DynamicEntryModel()
{
}

//=========INVOKABLE METHODS====================

void DynamicEntryModel::insert(int index, const QUrl &filePath)
{
    if(index < 0 || index > m_data2.count()) {
        qDebug() << index << " out of range [0 : ]" << m_data2.count();
        return;
    }

    if(filePath.isEmpty()) {
        return;
    }
    emit beginInsertRows(QModelIndex(), index, index);
    m_data2.insert(index, filePath);
    //Synch row => sub filePath (Url) => fileName (String)
    filePath.toEncoded().split('/').at(11);
    m_nameFile.insert(index, filePath.toEncoded().split('/').at(11));
    emit endInsertRows();
    emit countChanged(m_data2.count());
}

void DynamicEntryModel::append(const QUrl &filePath)
{
    insert(count(), filePath);

}

void DynamicEntryModel::remove(int index)
{
    if(index < 0 || index >= m_data2.count()) {
        return;
    }
    emit beginRemoveRows(QModelIndex(), index, index);
    m_data2.removeAt(index);
    emit endRemoveRows();
    emit countChanged(m_data2.count());
}

void DynamicEntryModel::clear()
{
    emit beginResetModel();
    m_data2.clear();
    m_nameFile.clear();
    emit endResetModel();
}

//Search function
void DynamicEntryModel::cppMethod(QString parameter)
{
    qDebug() << "Calling Qml method";
    callJSMethod(parameter);

}

void DynamicEntryModel::setQmlRootObject(QObject *value)
{
    qmlRootObject = value;
}

QUrl DynamicEntryModel::get(int index)
{
    if(index < 0 || index >= m_data2.count()) {
        return QUrl();
    }
    return m_data2.at(index);
}

QString DynamicEntryModel::getName(int index)
{
    if(index < 0 || index >= m_nameFile.count()) {
        return QString();
    }
    return m_nameFile.at(index);
}

void DynamicEntryModel::resetQmlModel()
{
    qDebug() << "qmlValue in Reset before path: " << qmlValue;
    pathFolder = "C:/Users/ADMIN/Desktop/lamle/MusicApp/MusicApp/music";
    qDebug() << "qmlValue in Reset before clear: " << qmlValue;
    clear();
    qDebug() << "qmlValue in Reset after clear: " << qmlValue;
    //pathData(pathFolder);
    nameFileData(pathFolder);
}

QString DynamicEntryModel::test() const
{
    return qmlValue;
}

void DynamicEntryModel::getQmlValue(QString ipQmlValue)
{
    qDebug() << "ipQmlValue: " << ipQmlValue;
    qmlValue = ipQmlValue;
    qDebug() << "qmlValue: " << qmlValue;
    clear();

    //test

    //return ipQmlValue;
}

int DynamicEntryModel::rowCount(const QModelIndex &parent) const
{
    //qDebug() << "rowCount";
    Q_UNUSED(parent);

    return m_data2.count();
}

QVariant DynamicEntryModel::data(const QModelIndex &index, int role) const
{
    qDebug() << "data " ;
    int row = index.row();

    if(row < 0 || row >= m_data2.count()) {
        return QVariant();
    }


    switch(role) {
    case FileUrlRole:
        qDebug() << "fileName case: " << m_data2.at(row);
        return m_data2.at(row);

    case FileNameRole:
        qDebug() << "fileName case: " << m_nameFile.at(row);
        return m_nameFile.at(row);

    }

    return QVariant();
}

int DynamicEntryModel::count() const
{
    qDebug() << "count " ;
    return rowCount(QModelIndex());
}

void DynamicEntryModel::pathData(QString path)
{
    QDir dirObj(path);
    for(const QFileInfo &var : dirObj.entryList(QDir::AllDirs | QDir::Files |QDir::NoDotAndDotDot))
    {
        qDebug() << var.fileName();
        //convert filtPath to url
        QUrl url = QUrl(var.filePath());
        QUrl baseUrl = QUrl("file:///C:/Users/ADMIN/Desktop/lamle/MusicApp/MusicApp/music/");
        //C:/Users/ADMIN/Desktop/lamle/MusicApp/MusicApp
        qDebug() << baseUrl.resolved(url);
        m_data2.append(baseUrl.resolved(url));
    }
}

void DynamicEntryModel::nameFileData(QString path)
{
    QDir dirObj(path);
    qDebug() << "qmlValue: " << qmlValue;

    for(const QFileInfo &var : dirObj.entryList(QDir::AllDirs | QDir::Files |QDir::NoDotAndDotDot))
    {
        //qmlValue = getQmlValue()
        if(!qmlValue.isEmpty())
        {
            qDebug() << "here " << var.fileName().contains(qmlValue);
        }
        m_nameFile.append(var.fileName());
    }
}

QHash<int, QByteArray> DynamicEntryModel::roleNames() const
{
    qDebug() << "Hash " ;
    return m_roleNames;
}

void DynamicEntryModel::callJSMethod(QString param)
{
    QVariant returnedValue;
    QVariant cppParameter = QVariant::fromValue(param);

    QMetaObject::invokeMethod(qmlRootObject, "sendInputToCpp",
                              Q_RETURN_ARG(QVariant, returnedValue),
                              Q_ARG(QVariant, cppParameter));

    qDebug() << "returnedValue: " << returnedValue.toString();

    //qmlValue = returnedValue.toString();
}
