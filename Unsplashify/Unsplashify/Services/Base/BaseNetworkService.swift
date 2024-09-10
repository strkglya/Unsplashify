//
//  BaseNetworkService.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import Foundation

protocol BaseNetworkServiceProtocol {
    func createRequest(for url: URL?, httpMethod: HTTPMethod) -> URLRequest?
    func executeRequest<T: Codable>(request: URLRequest) async throws -> T
}

final class BaseNetworkService: BaseNetworkServiceProtocol {
    private let accessKey = "74hxXpEyJjYodtYuABDqeXzDJYIJsu8cmiog2r3Bi14"

    func createRequest(for url: URL?, httpMethod: HTTPMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        return request
    }

    func executeRequest<T: Codable>(request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invaildData
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodeFailure
        }
    }
}
