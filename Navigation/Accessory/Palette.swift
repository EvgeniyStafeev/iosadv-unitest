//
//  Palette.swift
//  Navigation
//
//  Created by Евгений Стафеев on 04.02.2023.
//

import UIKit

struct Palette {

    static let appBackground = UIColor.createColor(light: .white, dark: .systemGray6)
    static let tabbar = UIColor.createColor(light: .black, dark: .white)
    static let userHeader = UIColor.createColor(
        light: UIColor(red: 163/255, green: 180/255, blue: 214/255, alpha: 1),
        dark: UIColor(red: 48/255, green: 67/255, blue: 83/255, alpha: 1))
    static let title = UIColor.createColor(
        light: UIColor(red: 37/255, green: 45/255, blue: 105/255, alpha: 1),
        dark: UIColor(red: 186/255, green: 219/255, blue: 162/255, alpha: 1))

}
