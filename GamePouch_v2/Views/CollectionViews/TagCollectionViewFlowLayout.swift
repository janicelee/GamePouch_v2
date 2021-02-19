//
//  TagCollectionViewFlowLayout.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-22.
//

import UIKit

class TagCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // Left align cells in collection view:
    // Uses max y position of the new element to determine when new line is needed
    // Origin x position of new element is set to left section inset when element is placed on new line, otherwise set to increase by minimumInteritemSpacing from the previous element's width
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var updatedAttributes: [UICollectionViewLayoutAttributes] = []
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            let updatedAttribute = layoutAttribute.copy() as! UICollectionViewLayoutAttributes
            
            if updatedAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            updatedAttribute.frame.origin.x = leftMargin

            leftMargin += updatedAttribute.frame.width + minimumInteritemSpacing
            maxY = max(updatedAttribute.frame.maxY , maxY)
            updatedAttributes.append(updatedAttribute)
        }
        return updatedAttributes
    }
}
