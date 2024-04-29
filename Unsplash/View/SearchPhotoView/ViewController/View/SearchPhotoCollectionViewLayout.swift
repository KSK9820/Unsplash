//
//  SearchPhotoCollectionViewLayout.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/05.
//

import UIKit

final class SearchPhotoCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: TwoColumnCollectionViewLayoutDelegate?
    
    private var numberOfSections: Int {
        guard let collectionView = collectionView else {
            return 0
        }
        
        return collectionView.numberOfSections
    }
    
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 4
    
    private var headerAttributesCache: [UICollectionViewLayoutAttributes] = []
    private var itemAttributeCache: [[UICollectionViewLayoutAttributes]] = [[],[]]
    
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
        
        
        for section in 0..<numberOfSections {
            if section == 0 {
                // header view
                let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerAttribute.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: headerHeight)
                headerAttributesCache.append(headerAttribute)
                
                // cell view
                let columnWidth = contentWidth / CGFloat(numberOfColumns)
                
                var xOffset: [CGFloat] = []
                
                for column in 0..<numberOfColumns {
                    xOffset.append(CGFloat(column) * columnWidth)
                }
                
                var column = yOffset.isEmpty ? 0: (yOffset[0] > yOffset[1] ? 1 : 0)
                
                for item in 0..<collectionView.numberOfItems(inSection: section) {
                    let indexPath = IndexPath(item: item, section: section)
                    let height = cellPadding * 2 + 30
                    let frame = CGRect(x: xOffset[column],
                                       y: yOffset[column],
                                       width: columnWidth,
                                       height: height)
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    
                    itemAttributeCache[section].append(attributes)
                    
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffset[column] = yOffset[column] + height
                    
                    column = yOffset[0] > yOffset[1] ? 1 : 0
                }
            }
            if section == 1 {
                // header view
                let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                
                headerAttribute.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: headerHeight)
                headerAttributesCache.append(headerAttribute)
                
                // cell view
                let columnWidth = contentWidth / CGFloat(numberOfColumns)
                
                var xOffset: [CGFloat] = []
                
                for column in 0..<numberOfColumns {
                    xOffset.append(CGFloat(column) * columnWidth)
                }
                
                var column = yOffset.isEmpty ? 0: (yOffset[0] > yOffset[1] ? 1 : 0)
                //            let currentIndex = itemAttributeCache.count
                
                for item in 0..<collectionView.numberOfItems(inSection: section) {
                    let indexPath = IndexPath(item: item, section: section)
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
                    
                    itemAttributeCache[section].append(attributes)
                    
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffset[column] = yOffset[column] + height
                    
                    column = yOffset[0] > yOffset[1] ? 1 : 0
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for section in 0..<numberOfSections {
            for attributes in itemAttributeCache[section] {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }

        visibleLayoutAttributes.append(contentsOf: headerAttributesCache.filter { rect.intersects($0.frame) })
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        itemAttributeCache[indexPath.section][indexPath.item]
    }

}

