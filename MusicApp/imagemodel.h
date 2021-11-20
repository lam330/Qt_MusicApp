#ifndef IMAGEMODEL_H
#define IMAGEMODEL_H

#include <QtCore>
#include <QtGui>
#include <QAbstractListModel>
#include <QFileDialog>
#include <stdlib.h>
#include <time.h>

class ImageModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    enum RoleNames {
        ImageRole = Qt::UserRole,
    };

    explicit ImageModel(QObject *parent = 0);
    ~ImageModel();

    //Image
    Q_INVOKABLE QUrl getImageUrl();

public: // interface QAbstractListModel
    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;
    int count() const;

    //Collect image url
    void imagePathData(QString path);

signals:
    void countChanged(int arg);
    void cppTimer(int value);

protected: // interface QAbstractListModel
    virtual QHash<int, QByteArray> roleNames() const;

private:
    QList<QUrl> mImageData;
    QHash<int, QByteArray> m_roleNames;
    int m_count;
    int mIndex;
    QString imageFolderPath;

    QTimer *mTimer;


};

#endif // IMAGEMODEL_H
