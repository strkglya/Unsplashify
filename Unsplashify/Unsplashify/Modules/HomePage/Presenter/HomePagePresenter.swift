//
//  HomePagePresenter.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import UIKit

protocol HomePagePresenterProtocol {
    func loadAllPhotos() async
    func getPhotos() -> [PhotoInfoModel]
    func findBySearchTerm(searchWord: String) async
    func addSearchTermToRecent(_ searchTerm: String)
    func loadRecentSearches()
    func getFilteredSearches() -> [String]
    func filterByTerm(searchTerm: String)
}

final class HomePagePresenter: HomePagePresenterProtocol {

    private enum Constants {
        static let maximumRecentTerms = 5
    }

    // MARK: - Properties

    private var service: UnsplashServiceProtocol?
    private var userDefaultsManager: UserDefaultsManagerProtocol?
    private weak var viewController: HomePageViewControllerProtocol?

    private var photos = [PhotoInfoModel]() 

    private var recentSearches: [String] = []
    private var filteredRecentSearches: [String] = [] {
        didSet {
            viewController?.updateSearchTerms()
        }
    }
    
    init(
        viewController: HomePageViewControllerProtocol,
        userDefaultsManager: UserDefaultsManagerProtocol
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }

    // MARK: - Methods

    func loadRecentSearches() {
        recentSearches = userDefaultsManager?.recentSearches ?? []
        filteredRecentSearches = recentSearches
    }

    func addSearchTermToRecent(_ searchTerm: String) {
        if recentSearches.contains(searchTerm) {
            return
        }
        recentSearches.append(searchTerm)
        if recentSearches.count > Constants.maximumRecentTerms {
            recentSearches.removeFirst()
        }
        saveRecentSearches()
    }

    func filterByTerm(searchTerm: String) {
        if searchTerm.isEmpty {
            filteredRecentSearches = recentSearches
        } else {
            filteredRecentSearches = recentSearches.filter {
                $0.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }

    func getFilteredSearches() -> [String] {
        return filteredRecentSearches
    }

    func getPhotos() -> [PhotoInfoModel] {
        return photos
    }

    func loadAllPhotos() async {
        do {
            let result = try await service?.getAllPhotos() ?? []
            let newPhotos = mapToPhotoInfoModels(from: result)
            photos = newPhotos
            await loadImagesForPhotos(from: result)
            viewController?.updateAfterLoad()
        } catch {
            print("Ошибка загрузки фотографий: \(error)")
        }
    }

    func findBySearchTerm(searchWord: String) async {
        do {
            let result = try await service?.searchForPhotos(query: searchWord) ?? UnsplashSearchResponse(results: [])

            let searchResult = result.results
            let newPhotos = mapToPhotoInfoModels(from: searchResult)
            photos = newPhotos
            await loadImagesForPhotos(from: searchResult)
            viewController?.updateAfterLoad()
        } catch {
            print(error.localizedDescription)
        }
    }
    // MARK: - Private Methods

    private func mapToPhotoInfoModels(from results: [UnsplashServiceResponse]) -> [PhotoInfoModel] {
        return results.map {
            PhotoInfoModel(
                image: nil,
                authorName: $0.user.name,
                description: $0.description,
                likes: $0.likes,
                location: $0.user.location,
                bio: $0.user.bio
            )
        }
    }

    private func saveRecentSearches() {
        userDefaultsManager?.recentSearches = recentSearches
    }

    private func loadImagesForPhotos(from photoResponses: [UnsplashServiceResponse]) async {
        for (index, photoResponse) in photoResponses.enumerated() {
            if let imageURL = URL(string: photoResponse.urls.regular) {
                do {
                    let image = try await transformImage(from: imageURL)
                    if index < photos.count {
                        photos[index].image = image
                    }
                } catch {
                    print("Ошибка загрузки изображения: \(error)")
                }
            }
        }
    }

    private func transformImage(from url: URL) async throws -> UIImage? {

        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NetworkError.invaildData
        }
        return image
    }

    // MARK: - Injection

    func set(service: UnsplashServiceProtocol) {
        self.service = service
    }
}
