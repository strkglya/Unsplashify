//
//  PhotoDetailsViewController.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import UIKit

protocol PhotoDetailsViewControllerProtocol: AnyObject {
    func update(model: PhotoInfoModel)
    func present(controller: UIViewController)
}

final class PhotoDetailsViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {

        static let imageViewCornerRadius: CGFloat = 16
        static let imageViewHeight: CGFloat = 400
        static let imageViewTopOffset: CGFloat = 12
        static let imageViewSidesOffset: CGFloat = 16

        static let stackViewSpacing: CGFloat = 8
        static let stackViewSidesOffset: CGFloat = 16

        static let saveButtonFontSize: CGFloat = 18
        static let saveButtonCornerRadius: CGFloat = 20
        static let saveButtonBorderWidth: CGFloat = 3
        static let saveButtonBottomPadding: CGFloat = -16
        static let saveButtonHeight: CGFloat = 48
        static let saveButtonSidesOffset: CGFloat = 16

    }

    // MARK: - Properties
    
    private lazy var detailsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .redraw
        return imageView
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 18,
            weight: .semibold
        )
        label.text = "This is author name"
        label.numberOfLines = .zero
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        label.text = "This is a description"
        label.numberOfLines = .zero
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.spacing = Constants.stackViewSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var shareButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(
            Images.PhotoDetailsViewController.share.image,
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(shareImage),
            for: .touchUpInside
        )
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()

    private lazy var saveImageButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(
            ofSize: Constants.saveButtonFontSize,
            weight: .bold
        )
        button.setTitle(
            LocalizedString.PhotoDetailsViewController.saveButtonTitle,
            for: .normal
        )
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = Constants.saveButtonCornerRadius
        button.layer.borderWidth = Constants.saveButtonBorderWidth
        button.addTarget(
            self,
            action: #selector(saveImage),
            for: .touchUpInside
        )
        return button
    }()

    private var presenter: PhotoDetailsPresenterProtocol?

    // MARK: - Override

    override func viewDidLoad() {
        view.backgroundColor = .white
        presenter?.getImage()
        addSubviews()
        setUpNavBar()
        setUpConstraints()
    }

    // MARK: - Methods

    // MARK: - Private Methods

    private func addSubviews() {
        view.addSubview(detailsImageView)
        view.addSubview(textStackView)
        view.addSubview(saveImageButton)
    }

    private func setUpNavBar() {
        navigationItem.rightBarButtonItem = shareButton
    }

    private func setUpConstraints() {
        detailsImageView.translatesAutoresizingMaskIntoConstraints = false
        saveImageButton.translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailsImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.imageViewTopOffset
            ),
            detailsImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.imageViewSidesOffset
            ),
            detailsImageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, 
                constant: -Constants.imageViewSidesOffset
            ),
            detailsImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewHeight),

            textStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.stackViewSidesOffset
            ),
            textStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.stackViewSidesOffset
            ),
            textStackView.topAnchor.constraint(
                equalTo: detailsImageView.bottomAnchor,
                constant: Constants.stackViewSidesOffset
            ),

            saveImageButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Constants.saveButtonSidesOffset
            ),
            saveImageButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.saveButtonSidesOffset
            ),
            saveImageButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.saveButtonSidesOffset
            ),
            saveImageButton.heightAnchor.constraint(equalToConstant: Constants.saveButtonHeight)
        ])
    }

    @objc private func saveImage() {
        guard let image = detailsImageView.image else {
            return
        }
        presenter?.saveImage(image: image)
    }

    @objc private func shareImage() {
        presenter?.shareImage()
    }

    // MARK: - Injection

    func set(presenter: PhotoDetailsPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - Extension PhotoDetailsViewControllerProtocol

extension PhotoDetailsViewController: PhotoDetailsViewControllerProtocol {
    
    func update(model: PhotoInfoModel) {
        detailsImageView.image = model.image
        authorLabel.text = model.authorName
        descriptionLabel.text = model.description
    }

    func present(controller: UIViewController) {
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}
