//
//  PhotoCollectionLayout.swift
//  Unsplashify
//
//  Created by Александра Среднева on 7.09.24.
//

import UIKit

protocol PhotoCollectionLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

class PhotoCollectionLayout: UICollectionViewLayout {

    enum Columns {
        case one
        case two

        var columnsAmount: Int {
            switch self {
            case .one:
                return 1
            case .two:
                return 2
            }
        }
    }

    var delegate: PhotoCollectionLayoutDelegate?

    var numberOfColumns: Columns = .two
    var cellPadding: CGFloat = 5.0

    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return (collectionView!.bounds.width - (insets.left + insets.right))
    }

    private var cache: [UICollectionViewLayoutAttributes] = []

    override func prepare() {
            super.prepare()
        cache.removeAll()
        contentHeight = 0
        guard let collectionView = collectionView else { return }

        let columnWidth = CGFloat(numberOfColumns.columnsAmount) > 0 ? contentWidth / CGFloat(numberOfColumns.columnsAmount) : contentWidth
            var xOffsets = [CGFloat]()
        for column in 0..<numberOfColumns.columnsAmount {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            var column = 0
        var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns.columnsAmount)

            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)

                let width = columnWidth - (cellPadding * 2)

                let photoHeight = delegate?.collectionView(collectionView: collectionView, heightForPhotoAt: indexPath, with: width) ?? 180
                let captionHeight = delegate?.collectionView(collectionView: collectionView, heightForCaptionAt: indexPath, with: width) ?? 44
                let height = cellPadding + photoHeight + captionHeight + cellPadding

                let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)

                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] += height

                if let minYOffset = yOffsets.min(), let nextColumn = yOffsets.firstIndex(of: minYOffset) {
                    column = nextColumn
                }
            }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    func toggleNumberOfColumns() {
        numberOfColumns = (numberOfColumns == .one) ? .two : .one
        invalidateLayout()
    }
}
