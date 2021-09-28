//
//  ResultViewCell.swift
//  weecare-ios-challenge
//
//  Created by Enrique Florencio on 9/28/21.
//

import Foundation
import UIKit
public class ResultTableViewCell: UITableViewCell {
    public var categoryString: String? {
        didSet {
            if let categoryString = categoryString {
                categoryLabel.text = categoryString
                layoutIfNeeded()
            }
        }
    }
    public let circularView = UIView()
    private let categoryLabel = UILabel()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        circularView.layer.cornerRadius = (circularView.frame.width) / 2
        circularView.layer.borderColor = UIColor.lightGray.cgColor
        circularView.layer.borderWidth = 1
        categoryLabel.sizeToFit()
    }
    
    private func configureLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textAlignment = .left
        categoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
        ])
    }
    
    private func configureButton() {
        circularView.translatesAutoresizingMaskIntoConstraints = false
        circularView.clipsToBounds = true
        circularView.layer.masksToBounds = false
        
        addSubview(circularView)
        NSLayoutConstraint.activate([
            circularView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            circularView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circularView.widthAnchor.constraint(equalToConstant: 20),
            circularView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

