//
//  CustomCollectionViewFlowLayout.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/20.
//

import UIKit

protocol FlexibleHeightCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class FlexibleHeightCollectionViewLayout: UICollectionViewFlowLayout {
    weak var delegate: FlexibleHeightCollectionViewLayoutDelegate!
    
    let cellPadding: CGFloat = 0
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        
        var yOffset: CGFloat = 0
        let cellOffset: CGFloat = 1
        
        for item in cache.count ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            
            let height = cellPadding * 2 + photoHeight
            
            let frame = CGRect(x: 0, y: yOffset, width: contentWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            yOffset += ceil(height + cellOffset)
            
            contentHeight = max(contentHeight, frame.maxY)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard cache.count > indexPath.item else { return cache[cache.count - 1] }
        return cache[indexPath.item]
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
    }
}
