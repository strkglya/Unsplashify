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
            return String("Failed to make a request")
        case .invalidUrl:
            return String("Invalid url and/or query")
        case .noResponse:
            return String("No response from the server")
        case .unauthorized:
            return String("Unathorized access to the server")
        case .forbidden:
            return String("API access rate exceeded")
        case .notFound:
            return String("Requested page was not found")
        case .unexpectedStatusCode(let code):
            return String("Unexpected status code \(code)")
        case .invaildData:
            return String("Failed to read data")
        case .decodeFailure:
            return String("Failed to decode data")
        case .unknown(let message):
            return String(message)
        }
    }
}
