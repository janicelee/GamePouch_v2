//
//  InternalError.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-09.
//

import Foundation

enum InternalError: String, Error {
    case generic = "Something went wrong.\n Please try again."
    
    // MARK: - Networking errors
    
    case invalidURL = "Invalid URL."
    case unableToCompleteRequest = "Unable to complete request."
    case invalidResponse = "Invalid response from the server."
    case invalidData = "Invalid data from the server."
    case unableToParse = "Unable to parse data from the server."

    
    // MARK: - Persistence errors
    
    case unableToRetrieveManagedContext = "Unable to retrieve managed context."
    case unableToVerifyFavorite = "Unable to verify if this game is in favorites."
    case unableToRetrieveFavorites = "Unable to retrieve favorites."
    case unableToSaveFavorite = "Unable to save favorite."
    case unableToDeleteFavorite = "Unable to delete favorite."
}
