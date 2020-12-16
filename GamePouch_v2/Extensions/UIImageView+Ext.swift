//
//  UIImageView+Ext.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-14.
//

import UIKit

extension UIImageView {
    
    func setImage(from urlString: String) {
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
