//
//  LoginButton.swift
//  Navigation
//
//  Created by Евгений Стафеев on 04.02.2023.
//

import UIKit

final class LoginButton: UIButton {

//  FIXIT: вернуть alpha = 0.8
    override var isSelected: Bool {
        didSet {
            alpha = isSelected ? 0.5 : 1.0
        }
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isHighlighted ? 1.0 : 0.5
        }
    }

}
