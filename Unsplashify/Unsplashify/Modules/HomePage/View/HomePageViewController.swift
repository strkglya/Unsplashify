//
//  ViewController.swift
//  Unsplashify
//
//  Created by Александра Среднева on 7.09.24.
//

import UIKit
import AVFoundation

protocol HomePageViewControllerProtocol: AnyObject {
    func update()
}

final class HomePageViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let numberOfItemsPerRow: CGFloat = 2
        static let topSectionInset: CGFloat = 23
        static let leadingTrailingSectionOffset: CGFloat = 16
        static let bottomSectionInset: CGFloat = 10
        static let minimumInteritemSpacing: CGFloat = 10
        static let captionFontSize: CGFloat = 15
        static let topPadding: CGFloat = 8
        static let bottomPadding: CGFloat = 12
        static let maxCaptionHeight: CGFloat = 64.0
    }

    // MARK: - Properties

    private var presenter: HomePagePresenterProtocol?
    private lazy var images = [PhotoInfoModel]()
    private lazy var photosCollectionView: UICollectionView = {

        let layout = PhotoCollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(
            HomePageCollectionCell.self,
            forCellWithReuseIdentifier: String(describing: HomePageCollectionCell.self)
        )

        collectionView.contentInset = UIEdgeInsets(
            top: Constants.topSectionInset,
            left: Constants.leadingTrailingSectionOffset,
            bottom: Constants.bottomSectionInset,
            right: Constants.leadingTrailingSectionOffset
        )

        layout.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadPhotos()
        addSubviews()
        setUpConstraints()
    }

    // MARK: - Methods

    // MARK: - Private Methods

    private func addSubviews() {
        view.addSubview(photosCollectionView)
    }

    private func loadPhotos() {
        Task {
            guard let presenter = presenter else {
                return
            }
            await presenter.loadPhotos()
            self.images = presenter.getPhotos()
            self.photosCollectionView.reloadData()
        }
    }

    private func setUpConstraints() {

        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Injection
    func set(presenter: HomePagePresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - Extension: UICollectionViewDelegate

extension HomePageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = PhotoDetailsBuilder(context: images[indexPath.row]).toPresent()
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

// MARK: - Extension: UICollectionViewDataSource

extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: HomePageCollectionCell.self),
            for: indexPath
        ) as? HomePageCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(
            image: images[indexPath.row].image,
            text: images[indexPath.row].description
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let totalWidth = collectionView.frame.width
        let totalInsets = collectionView.contentInset.left + collectionView.contentInset.right + Constants.minimumInteritemSpacing
        let availableWidth = totalWidth - totalInsets
        let itemSize = availableWidth / Constants.numberOfItemsPerRow
        return CGSize(width: itemSize, height: itemSize)
    }
}

// MARK: - Extension: PhotoCollectionLayoutDelegate

extension HomePageViewController: PhotoCollectionLayoutDelegate {

    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let boundingRect = CGRect(
            x: .zero,
            y: .zero,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        guard let image = images[indexPath.row].image else {
            return 0
        }
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
        return rect.size.height
    }

    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {

        let topPadding = Constants.topPadding
        let bottomPadding = Constants.bottomPadding
        let captionFont = UIFont.systemFont(ofSize: Constants.captionFontSize)
        let captionHeight = height(
            for: "AAAAA rigurier woijgfwiegjiowg wiw",
            with: captionFont,
            width: width
        )
        let height = topPadding + captionHeight + bottomPadding
        return height
    }

    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(Constants.maxCaptionHeight)
        let textAttributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(
            with: CGSize(
                width: width,
                height: maxHeight
            ),
            options: .usesLineFragmentOrigin,
            attributes: textAttributes,
            context: nil
        )
        return ceil(boundingRect.height)
    }
}

extension HomePageViewController: HomePageViewControllerProtocol {
    func update() {
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
        }
    }
}
