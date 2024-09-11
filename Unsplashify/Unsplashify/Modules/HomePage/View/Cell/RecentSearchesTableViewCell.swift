//
//  RecentSearchesTableViewCell.swift
//  Unsplashify
//
//  Created by Александра Среднева on 11.09.24.
//

import UIKit

class RecentSearchesTableViewCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let imageHeightWidth: CGFloat = 30
        static let imageLeadingOffset: CGFloat = 16
        static let labelLeadingOffset: CGFloat = 12
    }

    // MARK: - Properties

    private lazy var recentSearchImage: UIImageView = {
        let imageView = UIImageView()
        let image = Images.RecentSearchesTableViewCell.recent.image
        imageView.image = image
        return imageView
    }()

    private lazy var searchTermLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Methods

    func configure(text: String?) {
        searchTermLabel.text = text
    }

    // MARK: - Private Methods

    private func addSubviews() {
        addSubview(recentSearchImage)
        addSubview(searchTermLabel)
    }

    private func setUpConstraints() {
        recentSearchImage.translatesAutoresizingMaskIntoConstraints = false
        searchTermLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            recentSearchImage.heightAnchor.constraint(equalToConstant: Constants.imageHeightWidth),
            recentSearchImage.widthAnchor.constraint(equalToConstant: Constants.imageHeightWidth),
            recentSearchImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.imageLeadingOffset),
            recentSearchImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchTermLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchTermLabel.leadingAnchor.constraint(equalTo: recentSearchImage.trailingAnchor, constant: Constants.labelLeadingOffset),
            searchTermLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
