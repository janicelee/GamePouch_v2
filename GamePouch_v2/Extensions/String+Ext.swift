//
//  String+Ext.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
