//
//  WeeCareLabel.swift
//  weecare-ios-challenge
//
//  Created by Enrique Florencio on 9/29/21.
//

import Foundation
import UIKit

public class WeeCareLabel: UILabel {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSelf() {
        textAlignment = .left
        numberOfLines = 1
        lineBreakMode = .byTruncatingTail
        font = UIFont.systemFont(ofSize: 13)
    }
    
    public func setTextColor(color: UIColor) {
        textColor = color
    }
    
    public func setFont(font: UIFont) {
        self.font = font
    }
}
