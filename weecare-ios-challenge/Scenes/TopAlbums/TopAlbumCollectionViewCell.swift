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
    let albumLabel = UILabel()
    let artistNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 7
        albumLabel.sizeToFit()
    }
    
    private func commonInit() {
        albumImageView.clipsToBounds = true
        albumImageView.layer.cornerRadius = 7
        albumImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        albumImageView.layer.masksToBounds = true
        albumLabel.textColor = .black
        albumLabel.textAlignment = .left
        albumLabel.numberOfLines = 2
        albumLabel.lineBreakMode = .byTruncatingTail
        albumLabel.font = UIFont.systemFont(ofSize: 12)
        artistNameLabel.textColor = .darkGray
        artistNameLabel.textAlignment = .left
        artistNameLabel.numberOfLines = 1
        
        artistNameLabel.lineBreakMode = .byTruncatingTail
        artistNameLabel.font = UIFont.systemFont(ofSize: 12)
        stackView.axis = .vertical
        stackView.addArrangedSubview(albumLabel)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        [albumImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            // Container View
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            //ImageView
            albumImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            albumImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            albumImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            albumImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            //Stack
            stackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
}
