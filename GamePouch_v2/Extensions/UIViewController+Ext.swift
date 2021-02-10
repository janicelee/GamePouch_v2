//
//  UIViewController+Ext.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-09.
//

import UIKit

extension UIViewController {
    
    func showErrorAlertOnMainThread(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
