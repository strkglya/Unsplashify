//
//  ViewController.swift
//  Unsplashify
//
//  Created by Александра Среднева on 7.09.24.
//

import UIKit
import AVFoundation

protocol HomePageViewControllerProtocol: AnyObject {
    func check(data: [PhotoInfoModel])
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
        static let cellHeight: CGFloat = 40
        static let loadingLabelTopOffset: CGFloat = 16
        static let labelFontSize: CGFloat = 16
        static let iconsHeightWidth: CGFloat = 40
        static let searchStackOffset: CGFloat = 8
    }

    // MARK: - Properties

    private var presenter: HomePagePresenterProtocol?
    private lazy var photos = [PhotoInfoModel]()

    private lazy var photoSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.autocorrectionType = .no
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = LocalizedString.HomePageViewController.enterText
        return searchBar
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.HomePageViewController.sortIcon.image, for: .normal)
        button.tintColor = .black
        button.addTarget(
            self,
            action: #selector(sortByLikes),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var gridButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)
        button.tintColor = .black
        button.addTarget(
            self,
            action: #selector(changeGrid),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var searchStackView: UIStackView = {
        let searchStackView = UIStackView()
        searchStackView.addArrangedSubview(photoSearchBar)
        searchStackView.addArrangedSubview(sortButton)
        searchStackView.addArrangedSubview(gridButton)
        return searchStackView
    }()

    private lazy var recentSearchesTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "SearchCell"
        )
        return tableView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.HomePageViewController.loadingPhotos
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        label.textColor = .gray
        return label
    }()

    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.HomePageViewController.noPhotos
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()

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
        loadRecentSearches()
        loadPhotos()
        addSubviews()
        setUpConstraints()
    }

    // MARK: - Private Methods

    private func addSubviews() {
        view.addSubview(loadingIndicator)
        view.addSubview(loadingLabel)
        view.addSubview(noResultsLabel)
        view.addSubview(photoSearchBar)
        view.addSubview(photosCollectionView)
        view.addSubview(recentSearchesTableView)
        view.addSubview(searchStackView)
    }

    private func updateUIAfterLoading() {
        hideLoadingIndicator()
        photosCollectionView.reloadData()
        noResultsLabel.isHidden = !photos.isEmpty
        photosCollectionView.isHidden = photos.isEmpty
    }

    private func loadPhotos() {
        Task { [weak self] in
            guard let self = self, let presenter = presenter else {
                return
            }
            self.noResultsLabel.isHidden = true
            showLoadingIndicator()
            await presenter.loadAllPhotos()
        }
    }

    private func loadSearchPhotos(searchTerm: String) {
        Task { [weak self] in
            guard let self = self, let presenter = presenter else {
                return
            }
            self.noResultsLabel.isHidden = true
            showLoadingIndicator()

            addSearchTermToRecent(searchTerm)
            await presenter.findBySearchTerm(searchWord: searchTerm)

            photosCollectionView.setContentOffset(
                CGPoint(
                    x: -Constants.leadingTrailingSectionOffset,
                    y: -Constants.leadingTrailingSectionOffset
                ),
                animated: false
            )
            recentSearchesTableView.isHidden = true
        }
    }

    private func loadRecentSearches() {
        presenter?.loadRecentSearches()
    }

    private func addSearchTermToRecent(_ searchTerm: String) {
        presenter?.addSearchTermToRecent(searchTerm)
    }

    private func updateRecentSearchesHeight() {
        guard let presenter = presenter else {
            return
        }
        let newHeight = CGFloat(presenter.getFilteredSearches().count) * Constants.cellHeight
        if let oldConstraint = recentSearchesTableView.constraints.first(where: {
            $0.firstAttribute == .height
        }) {
            recentSearchesTableView.removeConstraint(oldConstraint)
        }
        recentSearchesTableView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
        view.layoutIfNeeded()
    }

    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        loadingLabel.isHidden = false
        photosCollectionView.isHidden = true
    }

    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingLabel.isHidden = true
        photosCollectionView.isHidden = false
    }

    private func setUpConstraints() {
        photoSearchBar.translatesAutoresizingMaskIntoConstraints = false
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        recentSearchesTableView.translatesAutoresizingMaskIntoConstraints = false
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        sortButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gridButton.widthAnchor.constraint(equalToConstant: Constants.iconsHeightWidth),
            gridButton.heightAnchor.constraint(equalToConstant: Constants.iconsHeightWidth),
            sortButton.widthAnchor.constraint(equalToConstant: Constants.iconsHeightWidth),
            sortButton.heightAnchor.constraint(equalToConstant: Constants.iconsHeightWidth),

            searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.searchStackOffset),
            searchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.searchStackOffset),
            searchStackView.heightAnchor.constraint(equalToConstant: Constants.iconsHeightWidth),
            

            photosCollectionView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: Constants.loadingLabelTopOffset),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            recentSearchesTableView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor),
            recentSearchesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentSearchesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func sortByLikes() {
        photos.sort { $0.likes > $1.likes }
        photosCollectionView.reloadData()
    }

    @objc private func changeGrid() {
        guard let layout = photosCollectionView.collectionViewLayout as? PhotoCollectionLayout else {
            return
        }
        layout.toggleNumberOfColumns()
        let isTwoColumns = layout.numberOfColumns == .two
        let iconName = isTwoColumns ? Images.HomePageViewController.gridIconForOne.image : Images.HomePageViewController.gridIconForTwo.image
        gridButton.setImage(iconName, for: .normal)
    }

    // MARK: - Injection

    func set(presenter: HomePagePresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - Extension: UITableViewDataSource

extension HomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getFilteredSearches().count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel?.text = presenter?.getFilteredSearches()[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedSearchTerm = presenter?.getFilteredSearches()[indexPath.row] else {
            return
        }
        photoSearchBar.text = selectedSearchTerm
        loadSearchPhotos(searchTerm: selectedSearchTerm)
        searchBarSearchButtonClicked(photoSearchBar)
    }
}

// MARK: - Extension: UITableViewDelegate

extension HomePageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

// MARK: - Extension: UISearchBarDelegate

extension HomePageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presenter = presenter else {
            return
        }
        presenter.filterByTerm(searchTerm: searchText)
        recentSearchesTableView.isHidden = presenter.getFilteredSearches().isEmpty
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            loadSearchPhotos(searchTerm: searchText)
        }
        recentSearchesTableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}

// MARK: - Extension: UICollectionViewDelegate

extension HomePageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = PhotoDetailsBuilder(context: photos[indexPath.row]).toPresent()
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

// MARK: - Extension: UICollectionViewDataSource

extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: HomePageCollectionCell.self),
            for: indexPath
        ) as? HomePageCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: photos[indexPath.row])
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

extension HomePageViewController: PhotoCollectionLayoutDelegate {

    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let boundingRect = CGRect(
            x: .zero,
            y: .zero,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        guard let image = photos[indexPath.row].image else {
            return .zero
        }
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
        return rect.size.height
    }

    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {

        let topPadding = Constants.topPadding
        let bottomPadding = Constants.bottomPadding
        let captionFont = UIFont.systemFont(ofSize: Constants.captionFontSize)
        let captionHeight = height(
            for: photos[indexPath.row].description,
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
    func check(data: [PhotoInfoModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.photos = self?.presenter?.getPhotos() ?? []
            self?.updateUIAfterLoading()
        }
    }

    func update() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.updateRecentSearchesHeight()
            self.recentSearchesTableView.reloadData()
        }
    }
}
