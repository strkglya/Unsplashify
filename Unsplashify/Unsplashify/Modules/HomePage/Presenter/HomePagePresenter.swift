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
}

final class HomePagePresenter: HomePagePresenterProtocol {

    // MARK: - Properties

    private var service: UnsplashServiceProtocol?
    private weak var viewController: HomePageViewControllerProtocol?

    private var photos = [PhotoInfoModel]() {
        didSet {
            print("\(photos)///////////////////////")
        }
    }

    init(viewController: HomePageViewControllerProtocol) {
        self.viewController = viewController
    }

    // MARK: - Methods

    func getPhotos() -> [PhotoInfoModel] {
        return photos
    }

    func loadAllPhotos() async {

        do {
            let result = try await service?.getAllPhotos() ?? []
            let newPhotos = result.map { 
                PhotoInfoModel(
                    image: nil,
                    authorName: $0.user.name,
                    description: $0.description,
                    likes: $0.likes
                )
            }

            photos = newPhotos

            for (index, photoResponse) in result.enumerated() {
                if let imageURL = URL(string: photoResponse.urls.regular) {
                    do {
                        let image = try await loadImage(from: imageURL)
                        if index < photos.count {
                            photos[index].image = image
                        }
                    } catch {
                        print("Ошибка загрузки изображения: \(error)")
                    }
                }
            }
            viewController?.update()
        } catch {
            print("Ошибка загрузки фотографий: \(error)")
        }
    }

    func findBySearchTerm(searchWord: String) async {
        do {
            let result = try await service?.searchForPhotos(query: searchWord) ?? UnsplashSearchResponse(results: [])

            let searchResult = result.results
            let newPhotos = searchResult.map {
                PhotoInfoModel(
                    image: nil,
                    authorName: $0.user.name,
                    description: $0.description,
                    likes: $0.likes
                )
            }
            photos = newPhotos

            for (index, photoResponse) in searchResult.enumerated() {
                if let imageURL = URL(string: photoResponse.urls.regular) {
                    do {
                        let image = try await loadImage(from: imageURL)
                        if index < photos.count {
                            photos[index].image = image
                        }
                    } catch {
                        print("Ошибка загрузки изображения: \(error)")
                    }
                }
            }
            viewController?.update()
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Private Methods

    func loadImage(from url: URL) async throws -> UIImage? {

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
