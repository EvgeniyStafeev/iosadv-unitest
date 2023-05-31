//
//  CheckerService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 04.02.2023.
//

import Foundation
import FirebaseAuth

protocol CheckerServiceProtocol: AnyObject {

    func checkCredentials(login: String, password: String, completion: @escaping (Result<Bool, AuthorizationError>) -> Void)
    func signUp(login: String, password: String, completion: @escaping (Result<Bool, AuthorizationError>) -> Void)
}

enum AuthorizationError: Error {
    case wrongPassword
    case badLoginFormat
    case unknowUser
}

final class CheckerService {

    static let shared = CheckerService()

    private init() {}

}

extension CheckerService: CheckerServiceProtocol {
    func checkCredentials(login: String, password: String, completion: @escaping (Result<Bool, AuthorizationError>) -> Void) {
        Auth.auth().signIn(withEmail: login, password: password) { authData, error in
            if error == nil {
                completion(.success(true))
            } else if error!.localizedDescription == "The password is invalid or the user does not have a password." {
                completion(.failure(.wrongPassword))
            } else if error!.localizedDescription == "The email address is badly formatted." {
                completion(.failure(.badLoginFormat))
            } else {
                completion(.failure(.unknowUser))
            }
        }
    }

    func signUp(login: String, password: String, completion: @escaping (Result<Bool, AuthorizationError>) -> Void) {
        Auth.auth().createUser(withEmail: login, password: password) { authData, error in
            if error == nil {
                print("Success register!")
                completion(.success(true))
            } else {
//                print(error!.localizedDescription)
            }
        }
        print("Sing Up")
    }
}
