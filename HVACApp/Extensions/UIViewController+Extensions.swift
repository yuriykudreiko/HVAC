//
//  UIViewController+Extensions.swift
//  HVACApp
//
//  Created by Yury Kudreika on 27.03.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static let myFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    static func createTextFieldWith(
        text: String,
        placeholder: String,
        keyboardType: UIKeyboardType,
        returnKey: UIReturnKeyType
    ) -> UITextField {
        let textField = UITextField()
        textField.text = text
        textField.placeholder = placeholder
        textField.font = myFont
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = keyboardType
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        
        return textField
    }
    
    static func createLabelWith(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = myFont
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }
    
    static func createButton(
        text: String,
        color: UIColor
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.titleLabel?.font = myFont
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
}
