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
    // Origin x position of new element is set to left section inset when element is placed on new line, otherwise increments by the element's width + min item spacing 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
