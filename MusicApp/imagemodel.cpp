#include "imagemodel.h"

ImageModel::ImageModel(QObject *parent)
    : QAbstractListModel(parent),
      mTimer(new QTimer(this)),
      mIndex(3)
{
    m_roleNames[ImageRole] = "imageUrl";
    imageFolderPath = "C:/Users/ADMIN/Desktop/lamle/MusicApp/MusicApp/images";
    imagePathData(imageFolderPath);

    //random
    srand((unsigned) time(0));
    connect(mTimer, &QTimer::timeout, [&]() mutable  {
        mIndex = (rand() % 9) + 1;
        //qDebug() << "index c++ = " << mIndex;
        emit cppTimer(mIndex);
    });

    mTimer->start(2700);
}

ImageModel::~ImageModel()
{

}

QUrl ImageModel::getImageUrl()
{
    if(mIndex < 0 || mIndex >= mImageData.count()) {
        return QUrl();
    }
    return mImageData.at(mIndex);
}

int ImageModel::rowCount(const QModelIndex &parent) const
{
    qDebug() << "rowCount";
    Q_UNUSED(parent);

    return mImageData.count();
}

QVariant ImageModel::data(const QModelIndex &index, int role) const
{
    qDebug() << "data " ;
    int row = index.row();

    if(row < 0 || row >= mImageData.count()) {
        return QVariant();
    }

    switch(role) {
    case ImageRole:
        qDebug() << "fileName case: " << mImageData.at(row);
        return mImageData.at(row);
    }

    return QVariant();
}

int ImageModel::count() const
{
    qDebug() << "count " ;
    return rowCount(QModelIndex());
}

void ImageModel::imagePathData(QString path)
{
    QDir dirObj(path);
    for(const QFileInfo &var : dirObj.entryList(QDir::AllDirs | QDir::Files |QDir::NoDotAndDotDot))
    {
        qDebug() << var.fileName();
        //convert filtPath to url
        QUrl url = QUrl((var.filePath()));
        QUrl baseUrl = QUrl("file:///C:/Users/ADMIN/Desktop/lamle/MusicApp/MusicApp/images/");
        //C:/Users/ADMIN/Desktop/lamle/MusicApp/MusicApp
        qDebug() << baseUrl.resolved(url);
        mImageData.append(baseUrl.resolved(url));
    }
}

QHash<int, QByteArray> ImageModel::roleNames() const
{
    return m_roleNames;
}
