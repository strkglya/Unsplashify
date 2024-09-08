//
//  HomePagePresenter.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import UIKit

protocol HomePagePresenterProtocol {
    func loadPhotos() async
    func getPhotos() -> [PhotoInfoModel]
}

final class HomePagePresenter: HomePagePresenterProtocol {
    // MARK: - Constants

    // MARK: - Properties
    private var page = 1
    private var service: UnsplashServiceProtocol?
    private var photos = [PhotoInfoModel]() {
        didSet {
            print(photos)
        }
    }
    // MARK: - Initializer

    // MARK: - Override

    // MARK: - Methods

    func getPhotos() -> [PhotoInfoModel] {
        return photos
    }

    func loadPhotos() async {
        do {
            // Получаем результат с сервиса
            let result = try await service?.getAllPhotos(page: page) ?? []

            // Создаем модели с пустыми изображениями
            self.photos = result.map { PhotoInfoModel(image: nil, authorName: $0.user.name) }
            
            // Асинхронная загрузка изображений для каждой фотографии
            for (index, photoResponse) in result.enumerated() {
                if let imageURL = URL(string: photoResponse.urls.regular) {
                    do {
                        // Загружаем изображение асинхронно
                        let image = try await loadImage(from: imageURL)
                        self.photos[index].image = image
                    } catch {
                        print("Ошибка загрузки изображения: \(error)")
                    }
                }
            }
            
        } catch {
            print("Ошибка загрузки фотографий: \(error)")
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
