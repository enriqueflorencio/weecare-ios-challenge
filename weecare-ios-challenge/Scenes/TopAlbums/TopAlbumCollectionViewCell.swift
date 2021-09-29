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
        //MARK: TODO- Revert the background color back to the original once I'm done working on the feature. Also remember to revert the build target back to iOS 14.5 as well.
        albumImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
//        albumImageView.contentMode = .scaleAspectFit
        albumImageView.clipsToBounds = true
        albumImageView.layer.cornerRadius = 7
        albumImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        albumImageView.layer.masksToBounds = true
        albumLabel.textColor = .darkGray
        albumLabel.textAlignment = .left
        albumLabel.numberOfLines = 0
        
        albumLabel.lineBreakMode = .byWordWrapping
        albumLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        artistNameLabel.textColor = .lightGray
        artistNameLabel.textAlignment = .left
        artistNameLabel.numberOfLines = 0
        
        artistNameLabel.lineBreakMode = .byWordWrapping
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
        
        let albumHeight = albumImageView.heightAnchor.constraint(equalToConstant: 100)
        albumHeight.priority = .defaultLow
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
            albumImageView.heightAnchor.constraint(equalToConstant: 120),
            albumImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            //Stack
            stackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            
            
            
//            albumImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
//            albumImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6)

            // ImageView
//            albumImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            albumImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            albumImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
//            albumImageView.widthAnchor.constraint(equalToConstant: 100),
//            albumHeight,
//
//            // Stack
//            stackView.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
//            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10)
        ])
    }
}
