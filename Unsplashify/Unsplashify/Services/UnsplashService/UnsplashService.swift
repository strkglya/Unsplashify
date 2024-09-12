//
//  UnsplashService.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import Foundation

private enum Constants {
    static let baseURL = "https://api.unsplash.com/"
}

protocol UnsplashServiceProtocol {
    func getAllPhotos() async throws -> [UnsplashServiceResponse]
    func searchForPhotos(query: String) async throws -> UnsplashSearchResponse
}

final class UnsplashService: UnsplashServiceProtocol {
    private var networkService: BaseNetworkServiceProtocol

    init(networkService: BaseNetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getAllPhotos() async throws -> [UnsplashServiceResponse] {
        guard var urlComponents = URLComponents(string: Constants.baseURL) else {
            throw NetworkError.invalidUrl
        }
        urlComponents.path = "/photos"
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "30")
        ]
        guard let request = networkService.createRequest(
            for: urlComponents.url,
            httpMethod: .get
        ) else {
            throw NetworkError.invalidUrl
        }
        return try await networkService.executeRequest(request: request)
    }

    func searchForPhotos(query: String) async throws -> UnsplashSearchResponse {
        guard var urlComponents = URLComponents(string: Constants.baseURL) else {
            return UnsplashSearchResponse(results: [])
        }
        urlComponents.path = "/search/photos"
        urlComponents.queryItems = [URLQueryItem(name: "query", value: query),
                                    URLQueryItem(name: "per_page", value: "30")
        ]
        guard let request = networkService.createRequest(
            for: urlComponents.url,
            httpMethod: .get
        ) else {
            throw NetworkError.noResponse
        }
        return try await networkService.executeRequest(request: request)
    }
}
