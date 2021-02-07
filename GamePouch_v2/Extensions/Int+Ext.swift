//
//  Int+Ext.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-03.
//

import UIKit

extension Int {
    
    func toOrdinalString(fontSize: CGFloat, superscriptFontSize: CGFloat, weight: UIFont.Weight) -> NSMutableAttributedString? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        let number = NSNumber(value: self)
        guard var result = formatter.string(from: number) else { return nil }
        result = result.replacingOccurrences(of: ",", with: "")
        
        let font: UIFont? = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let fontSuper: UIFont? = UIFont.systemFont(ofSize: superscriptFontSize, weight: weight)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font: font!])
        let location = result.count - 2
        
        attString.setAttributes([.font: fontSuper!,.baselineOffset: fontSize - 11], range: NSRange(location: location, length: 2))
        return attString
    }
}

