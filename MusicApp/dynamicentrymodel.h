#ifndef DYNAMICENTRYMODEL_H
#define DYNAMICENTRYMODEL_H

#include <QtCore>
#include <QtGui>
#include <QAbstractListModel>
#include <QFileDialog>

class DynamicEntryModel : public QAbstractListModel//, public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    enum RoleNames {
        FileUrlRole = Qt::UserRole,
        FileNameRole = Qt::UserRole + 2
    };

    explicit DynamicEntryModel(QObject *parent = nullptr);
    ~DynamicEntryModel();

    Q_INVOKABLE void insert(int index, const QUrl& filePath);
    Q_INVOKABLE void append(const QUrl& filePath);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void clear();

    Q_INVOKABLE void cppMethod(QString parameter);
    void setQmlRootObject(QObject *value);

    //Audio
    Q_INVOKABLE QUrl get(int index);
    Q_INVOKABLE QString getName(int index);

    //Reset
    Q_INVOKABLE void resetQmlModel();
    Q_INVOKABLE QString test() const;

public slots:
    void getQmlValue(QString qmlValue);

public: // interface QAbstractListModel
    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;
    int count() const;
    //Collect audio url
    void pathData(QString path);
    //Collect audio name
    void nameFileData(QString path);
    //Collect image url
    void imagePathData(QString path);


signals:
    void countChanged(int arg);

protected: // interface QAbstractListModel
    virtual QHash<int, QByteArray> roleNames() const;

private:
    QList<QString> m_nameFile;
    QList<QUrl> m_data2;
    QHash<int, QByteArray> m_roleNames;
    int m_count;
    QString pathFolder;
    QString qmlValue;//value from qml


    void callJSMethod(QString param);
    QObject * qmlRootObject;
};

#endif // DYNAMICENTRYMODEL_H
