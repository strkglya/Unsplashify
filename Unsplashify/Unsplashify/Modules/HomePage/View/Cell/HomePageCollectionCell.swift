//
//  HomePageCollectionCell.swift
//  Unsplashify
//
//  Created by Александра Среднева on 7.09.24.
//

import UIKit

class HomePageCollectionCell: UICollectionViewCell {

    // MARK: - Constants

    private enum Constants {
        static let labelFontSize: CGFloat = 12
        static let cornerRadiusDivider: CGFloat = 10
        static let labelLeadingTrailingOffset: CGFloat = 5
        static let labelBottomOffset: CGFloat = -5
        static let photoImageBottomOffset: CGFloat = -10
    }

    // MARK: - Properties

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.labelFontSize)
        label.numberOfLines = .zero
        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    // MARK: - Override

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = min(photoImageView.frame.width, photoImageView.frame.height) / Constants.cornerRadiusDivider
        photoImageView.layer.cornerRadius = radius
    }

    // MARK: - Methods

    func configure(image: UIImage?, text: String) {
        if let image = image {
            photoImageView.image = image
            activityIndicator.stopAnimating()
            descriptionLabel.text = text
        } else {
            activityIndicator.startAnimating()
            photoImageView.image = nil
        }
    }

    // MARK: - Private Methods

    private func addSubviews() {
        addSubview(activityIndicator)
        addSubview(photoImageView)
        addSubview(descriptionLabel)
    }

    private func setUpConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.labelLeadingTrailingOffset),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.labelLeadingTrailingOffset),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.labelBottomOffset),

            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: Constants.photoImageBottomOffset),

            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: - Injection

    // MARK: - Extension
}
