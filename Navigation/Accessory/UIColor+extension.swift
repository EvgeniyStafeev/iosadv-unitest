//
//  UIColor+extension.swift
//  Navigation
//
//  Created by Евгений Стафеев on 04.02.2023.
//

import UIKit

extension UIColor {

    static func createColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return light
        }
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .light ? light : dark
        }
    }

}
