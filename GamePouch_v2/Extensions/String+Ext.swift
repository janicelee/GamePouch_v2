//
//  String+Ext.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-16.
//

import Foundation

extension String {
    
    func isValidDisplayText() -> Bool {
        return !self.isEmpty && self != "0" && self != "0.0" && self != "Not Ranked"
    }
}
