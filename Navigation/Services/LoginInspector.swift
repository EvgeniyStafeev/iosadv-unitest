//
//  LoginInspector.swift
//  Navigation
//
//  Created by Евгений Стафеев on 26.01.2023.
//

import Foundation

class LoginInspector: LoginViewControllerDelegate {
    
//    func check(login: String, password: String) throws -> Bool {
//        guard login != "" && password != "" else { throw LoginError.noLetters }
//        guard password.count > 3 else { throw LoginError.shortPassword }
//        guard Checker.shared.check(login: login, password: password) else { throw LoginError.wrongUser }
//        return true
//    }

    func checkCredentials(login: String, password: String, completion: @escaping (Result<Bool, AuthorizationError>) -> Void) {
//        print("Checking user login inspector")
        CheckerService.shared.checkCredentials(login: login, password: password, completion: completion)
    }

    func signUp(login: String, password: String, completion: @escaping (Result<Bool, AuthorizationError>) -> Void) {
//        print("Sing Up login inspector")
        CheckerService.shared.signUp(login: login, password: password, completion: completion)
        
    }
    
}
/*
extension LoginInspector: CheckerServiceProtocol {
    func checkCredentials(login: String, password: String) {
        CheckerService.shared.checkCredentials(login: login, password: password)
    }

    func signUp(login: String, password: String) {
        CheckerService.shared.signUp(login: login, password: password)
    }
}
*/

// TASK #11-1
enum LoginError: Error {
    case wrongUser
    case wrongPassword
    case noLetters
    case shortPassword
}
