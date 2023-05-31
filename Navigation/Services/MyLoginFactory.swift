//
//  MyLoginFactory.swift
//  Navigation
//
//  Created by Евгений Стафеев on 04.02.2023.
//

import Foundation

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {

    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }

}
