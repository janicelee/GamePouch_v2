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
    case unableToParse = "Unable to parse data from the server"
    case unableToVerifyFavorite = "Unable to verify if this game is in favorites"
    case unableToRetrieveManagedContext = "Unable to retrieve managed context"
}

enum UserError: String, Error {
    case generic = "Something went wrong.\n Please try again."
    case unableToSaveFavorite = "Unable to save to favorites."
    case unableToDeleteFavorite = "Unable to delete from favorites."
    case unableToRetrieveFavorites = "There was an error while retrieving favorites."
}
