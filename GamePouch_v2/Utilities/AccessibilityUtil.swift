//
//  AccessibilityUtil.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-16.
//

import Foundation

// Matches labels like `2-4`
let rangeRegex = try! NSRegularExpression(pattern: "\\d+-\\d+")

// Matches labels like `2.8/5`
let scoreRegex = try! NSRegularExpression(pattern: "\\d+\\.\\d+\\/\\d+")


// Formats game label into readable accessibility text
func formatGameLabelToAccessibleText(_ text: String) -> String {
    if text == "N/A" { return "Not Available" }
    
    let range = NSRange(location: 0, length: text.utf16.count)
    if rangeRegex.firstMatch(in: text, options: [], range: range) != nil {
        return text.replacingOccurrences(of: "-", with: "to")
    }
    
    if scoreRegex.firstMatch(in: text, options: [], range: range) != nil {
        return text.replacingOccurrences(of: "/", with: " out of ")
    }
    return text
}
