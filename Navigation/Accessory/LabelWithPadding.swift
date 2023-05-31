//
//  LoginWithPadding.swift
//  Navigation
//
//  Created by Евгений Стафеев on 04.02.2023.
//

import UIKit

final class LabelWithPadding: UILabel {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10
    )

    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = textPadding
        super.drawText(in: rect.inset(by: insets))
    }
}
