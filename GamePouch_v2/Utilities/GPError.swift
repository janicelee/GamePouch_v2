//
//  GPError.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-01.
//

import Foundation

enum GPError: String, Error {
    case invalidURL = "Invalid URL"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "Invalid data from the server. Please try again."
    case unableToParse = "Unable to parse the data from the server. Please try again."
}
