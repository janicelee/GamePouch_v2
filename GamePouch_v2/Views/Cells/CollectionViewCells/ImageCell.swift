//
//  ImageCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-23.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static let reuseID = "ImageCell"
    private let imageView = GameImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(imageURL: String) {
        imageView.setImage(from: imageURL)
    }
    
    func clearImage() {
        imageView.setImageToPlaceholder()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
