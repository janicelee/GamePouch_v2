//
//  TagCollectionViewFlowLayout.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-22.
//

import UIKit

class TagCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // Left aligns cells in collection view:
    // Uses max y position of the new element to determine when new line is needed
    // Origin x position of new element is set to left section inset when placed on new line
    // Otherwise, set to previous element's width + minimumInteritemSpacing
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var updatedAttributes: [UICollectionViewLayoutAttributes] = []
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            let updatedAttribute = layoutAttribute.copy() as! UICollectionViewLayoutAttributes
            
            // Determines if element should be placed on next line
            if updatedAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            updatedAttribute.frame.origin.x = leftMargin
            
            // Calculates leftMargin for next attribute (if on same line)
            leftMargin += updatedAttribute.frame.width + minimumInteritemSpacing
            maxY = max(updatedAttribute.frame.maxY , maxY)
            updatedAttributes.append(updatedAttribute)
        }
        return updatedAttributes
    }
}
