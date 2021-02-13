//
//  Error+Ext.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-13.
//

import Foundation

extension Error {
    
    func getErrorMessage() -> String {
        var message = localizedDescription
        if let internalError = self as? InternalError {
            message = internalError.rawValue
        }
        return message
    }
}
