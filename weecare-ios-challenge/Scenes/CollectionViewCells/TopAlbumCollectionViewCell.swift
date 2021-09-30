//
//  TopAlbumTableViewCell.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

class TopAlbumCollectionViewCell: UICollectionViewCell {
    
    let albumImageView = UIImageView()
    let containerView = UIView()
    let stackView = UIStackView()
    let albumLabel = WeeCareLabel()
    let artistNameLabel = WeeCareLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureContainerView()
        configureAlbumImageView()
        configureStackView()
        configureAlbumLabel()
        configureArtistLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContainerView()
        configureAlbumImageView()
        configureStackView()
        configureAlbumLabel()
        configureArtistLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 7
    }
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    private func configureAlbumImageView() {
        albumImageView.clipsToBounds = true
        albumImageView.layer.cornerRadius = 7
        albumImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        albumImageView.layer.masksToBounds = true
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(albumImageView)
        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            albumImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            albumImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            albumImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.addArrangedSubview(albumLabel)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func configureAlbumLabel() {
        albumLabel.setTextColor(color: .black)
        stackView.addArrangedSubview(albumLabel)
    }
    
    private func configureArtistLabel() {
        artistNameLabel.setTextColor(color: .lightGray)
        stackView.addArrangedSubview(artistNameLabel)
    }
    
    
}
