//
//  AppErrors.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//

import Foundation

enum AppErrors: Error {
    
    case invalidUrl
    case failedToDecode
}

extension AppErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return NSLocalizedString("The URL used to call the api is invalid", comment: "Invalid URL")
        case .failedToDecode:
            return NSLocalizedString("Could not decode questions from data", comment: "Failed To Decode")
        }
    }
}
