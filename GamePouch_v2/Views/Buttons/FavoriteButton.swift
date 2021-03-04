//
//  FavoriteButton.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-20.
//

import UIKit

class FavoriteButton: UIButton {
    
    private let imageInset: CGFloat = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelectionStatus(active: Bool) {
        let image = active ? Images.filledHeart : Images.emptyHeart
        setImage(image, for: .normal)
        setAccessibilityAttributes(isFavorite: active)
    }
    
    private func setAccessibilityAttributes(isFavorite: Bool) {
        accessibilityLabel = isFavorite ? "Selected favorite" : "Unselected favorite"
        accessibilityHint = isFavorite ? "Double tap to un-favorite" : "Double tap to favorite"
    }
    
    // MARK: - Configuration
    
    private func configure() {
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: imageInset, left: imageInset, bottom: imageInset, right: imageInset)
        setImage(Images.emptyHeart, for: .normal)
    }
}
