//
//  TagCollectionView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-22.
//

import UIKit

class TagCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
