//
//  CustomButton.swift
//  Navigation
//
//  Created by Евгений Стафеев on 04.02.2023.
//

import UIKit

final class CustomButton: UIButton {

//    var callBack: (() -> Void)?
    private var buttonAction: () -> Void

    init(title: String, colorTitle: UIColor, bgdColor: UIColor, corneR: CGFloat, action: @escaping () -> Void) {
        self.buttonAction = action
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(colorTitle, for: .normal)
        self.backgroundColor = bgdColor
        self.layer.cornerRadius = corneR
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        buttonAction()
//        print("callBack")
    }
}
