//
//  GameImageView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-11.
//

import UIKit

class GameImageView: UIImageView {
    
    private let cornerRadius: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setImageToPlaceholder()
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    func setImage(from urlString: String) {
        BoardGameGeekClient.shared.downloadImage(from: urlString) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.contentMode = .scaleAspectFill
                self.image = image
            }
        }
    }
    
    func setImageToPlaceholder() {
        contentMode = .scaleAspectFit
        image = Images.placeholder
    }
}
