//
//  GameImageView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-11.
//

import UIKit

class GameImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        clipsToBounds = true
        image = Images.placeholder
        contentMode = .scaleAspectFill
    }
    
    func setImage(from urlString: String) {
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.image = image 
            }
        }
    }
}
