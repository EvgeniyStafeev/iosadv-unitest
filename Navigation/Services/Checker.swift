//
//  Checker.swift
//  Navigation
//
//  Created by Евгений Стафеев on 26.01.2023.
//

import Foundation

final class Checker {

    static let shared = Checker()

    private let login = "leopold"
    private let password = "peacemaker"

    private init() {}

    func check(login: String, password: String) -> Bool {
        return (self.login == login && self.password == password) ? true : false
    }

}

protocol LoginViewControllerDelegate: AnyObject {
//    func check(login: String, password: String) throws -> Bool
    func checkCredentials(login: String, password: String, completion: @escaping (Result<Bool, AuthorizationError>) -> Void)
    func signUp(login: String, password: String, completion: @escaping (Result<Bool, AuthorizationError>) -> Void)
}


