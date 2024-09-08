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
    func getAllPhotos(page: Int) async throws -> [UnsplashServiceResponse]
}

final class UnsplashService: UnsplashServiceProtocol {
    private var networkService: BaseNetworkServiceProtocol

    init(networkService: BaseNetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getAllPhotos(page: Int) async throws -> [UnsplashServiceResponse] {
        guard var urlComponents = URLComponents(string: Constants.baseURL) else {
            throw NetworkError.invalidUrl
        }
        urlComponents.path = "/photos"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let request = networkService.createRequest(for: urlComponents.url, httpMethod: .get) else {
            throw NetworkError.invalidUrl
        }
        return try await networkService.executeRequest(request: request)
    }
}
