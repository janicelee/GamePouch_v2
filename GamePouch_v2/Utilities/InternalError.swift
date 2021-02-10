//
//  InternalError.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-09.
//

import Foundation

enum InternalError: String, Error {
    case invalidURL = "Invalid URL"
    case unableToComplete = "Unable to complete request"
    case invalidResponse = "Invalid response from the server"
    case invalidData = "Invalid data from the server"
    case unableToParse = "Unable to parse the data from the server"
}

enum UserError: String {
    case generic = "Something went wrong.\n Please try again."
}
