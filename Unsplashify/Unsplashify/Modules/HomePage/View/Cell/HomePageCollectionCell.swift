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
        static let cornerRadiusDivider: CGFloat = 10
        static let labelLeadingTrailingOffset: CGFloat = 5
        static let labelBottomOffset: CGFloat = -5
        static let photoImageBottomOffset: CGFloat = -10
        static let likesLinesAmount = 1
        static let stackViewSpacing: CGFloat = 1
        static let descriptionLabelHeight: CGFloat = 50
        static let heartHeightWidth: CGFloat = 20
        static let likesStackWidth: CGFloat = 30
    }

    // MARK: - Properties

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = .zero
        return label
    }()

    private lazy var heartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.HomePageCollectionCell.heart.image
        imageView.tintColor = .black
        return imageView
    }()

    private lazy var likesAmountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.likesLinesAmount
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    private lazy var likesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(heartImage)
        stackView.addArrangedSubview(likesAmountLabel)
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(likesStackView)
        stackView.distribution = .fillProportionally
        stackView.spacing = Constants.stackViewSpacing
        return stackView
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

    func configure(model: PhotoInfoModel) {
        photoImageView.image = model.image
        descriptionLabel.text = model.formattedDescription
        likesAmountLabel.text = model.formattedLikes
    }

    // MARK: - Private Methods

    private func addSubviews() {
        addSubview(photoImageView)
        addSubview(descriptionStackView)
    }

    private func setUpConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        heartImage.translatesAutoresizingMaskIntoConstraints = false
        likesAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalToConstant: Constants.descriptionLabelHeight),

            descriptionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.labelLeadingTrailingOffset),
            descriptionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.labelLeadingTrailingOffset),
            descriptionStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.labelBottomOffset),

            heartImage.heightAnchor.constraint(equalToConstant: Constants.heartHeightWidth),
            heartImage.widthAnchor.constraint(equalToConstant: Constants.heartHeightWidth),
            likesAmountLabel.widthAnchor.constraint(equalToConstant: Constants.likesStackWidth),

            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: descriptionStackView.topAnchor, constant: Constants.photoImageBottomOffset)
        ])
    }
}
