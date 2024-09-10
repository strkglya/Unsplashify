//
//  NetworkError.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invaildRequest
    case invalidUrl
    case noResponse
    case unauthorized
    case forbidden
    case notFound
    case unexpectedStatusCode(code: Int)
    case invaildData
    case decodeFailure
    case unknown(message: String)

    var errorDescription: String? {
        switch self {
        case .invaildRequest:
            return NSLocalizedString("Failed to make a request", comment: "Invalid Request")
        case .invalidUrl:
            return NSLocalizedString("Invalid url and/or query", comment: "Invalid URL")
        case .noResponse:
            return NSLocalizedString("No response from the server", comment: "No Response")
        case .unauthorized:
            return NSLocalizedString("Unathorized access to the server", comment: "Unauthorized")
        case .forbidden:
            return NSLocalizedString("API access rate exceeded", comment: "Forbidden")
        case .notFound:
            return NSLocalizedString("Requested page was not found", comment: "Not Found")
        case .unexpectedStatusCode(let code):
            return NSLocalizedString("Unexpected status code \(code)", comment: "Unexpected Code")
        case .invaildData:
            return NSLocalizedString("Failed to read data", comment: "Invalid Data")
        case .decodeFailure:
            return NSLocalizedString("Failed to decode data", comment: "Decoding Failure")
        case .unknown(let message):
            return NSLocalizedString(message, comment: "Unknown Error")
        }
    }
}
