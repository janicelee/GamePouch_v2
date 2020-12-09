//
//  UITableView+Ext.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-04.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
