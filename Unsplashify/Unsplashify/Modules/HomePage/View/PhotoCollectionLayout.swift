//
//  PhotoCollectionLayout.swift
//  Unsplashify
//
//  Created by Александра Среднева on 7.09.24.
//

import UIKit

protocol PhotoCollectionLayoutDelegate: AnyObject {
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

class PhotoCollectionLayout: UICollectionViewLayout {

    weak var delegate: PhotoCollectionLayoutDelegate?

    var numberOfColumns: CGFloat = 2
    var cellPadding: CGFloat = 5.0

    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return (collectionView!.bounds.width - (insets.left + insets.right))
    }

    private var attributesCache = [UICollectionViewLayoutAttributes]()

    override func prepare() {

        guard let collectionView = collectionView,
              let delegate = delegate else {
            return
        }

        if attributesCache.isEmpty {
            let columnWidth = contentWidth / numberOfColumns
            var xOffsets = [CGFloat]()
            for column in 0..<Int(numberOfColumns) {
                xOffsets.append (CGFloat (column) * columnWidth)
            }
            var column = 0
            var yOffsets = [CGFloat] (repeating: 0, count: Int (numberOfColumns))

            for item in 0..<collectionView.numberOfItems (inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let width = columnWidth - cellPadding * 2

                let photoHeight = (delegate.collectionView(collectionView: collectionView, heightForPhotoAt: indexPath, with: width))
                let captionHeight: CGFloat = (delegate.collectionView(collectionView: collectionView, heightForCaptionAt: indexPath, with: width))
                let height = cellPadding + photoHeight + captionHeight + cellPadding

                let frame = CGRect (x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                attributes.frame = insetFrame
                attributesCache.append(attributes)

                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] = yOffsets[column] + height

                if column >= (Int(numberOfColumns) - 1) {
                    column = 0
                } else {
                    column += 1
                }
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in attributesCache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
