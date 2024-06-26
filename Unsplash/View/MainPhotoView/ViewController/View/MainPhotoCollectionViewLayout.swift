//
//  MainPhotoCollectionViewLayout.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/15.
//

import UIKit

final class MainPhotoCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: TwoColumnCollectionViewLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 4
    
    private var headerAttributesCache: [UICollectionViewLayoutAttributes] = []
    private var itemAttributeCache: [UICollectionViewLayoutAttributes] = []
    
    private var headerHeight: CGFloat = 50
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private lazy var yOffset: [CGFloat] = .init(repeating: headerHeight, count: numberOfColumns)
    
    // MARK: - override method
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        // header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
        
        headerAttribute.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: headerHeight)
        headerAttributesCache = [headerAttribute]
        
        // cell view
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset: [CGFloat] = []
        
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = yOffset.isEmpty ? 0: (yOffset[0] > yOffset[1] ? 1 : 0)
        let currentIndex = itemAttributeCache.count
        
        for item in currentIndex..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = delegate?.collectionView(collectionView,
                                                       heightForPhotoAtIndexPath: indexPath) ?? columnWidth
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            
            itemAttributeCache.append(attributes)
 
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = yOffset[0] > yOffset[1] ? 1 : 0
        }
 
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in itemAttributeCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }

        visibleLayoutAttributes.append(contentsOf: headerAttributesCache.filter {  rect.intersects($0.frame) })
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        itemAttributeCache[indexPath.item]
    }

}
