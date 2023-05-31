//
//  LoginViewModelTests.swift
//  NavigationTests
//
//  Created by Евгений Стафеев on 17.05.2023.
//

import Foundation
import XCTest
@testable import Navigation

class LoginViewModelTests: XCTestCase {

    let realmServiceMock = RealmServiceMock()
    let loginDelegateMock = LoginDelegateMock()
    let user = User(userName: "123", password: "456")

    func testRealmFetchFail() {
        let loginViewModel = LoginViewModel(loginDelegate: loginDelegateMock, realmService: realmServiceMock)
        realmServiceMock.fakeFetchUser = nil
//        XCTAssertEqual(loginViewModel.state, .noUser)
        loginViewModel.initialState()
        XCTAssertEqual(loginViewModel.state, .noUser)
    }
    func testRealmFetchSuccess() {
        let loginViewModel = LoginViewModel(loginDelegate: loginDelegateMock, realmService: realmServiceMock)
        realmServiceMock.fakeFetchUser = user
        XCTAssertEqual(loginViewModel.state, .noUser)
        loginViewModel.initialState()
        XCTAssertEqual(loginViewModel.state, .identifiedUser(user: realmServiceMock.fakeFetchUser!))
    }
    func testSuccessLogin() {
        let loginViewModel = LoginViewModel(loginDelegate: loginDelegateMock, realmService: realmServiceMock)
        loginDelegateMock.fakeResult = .success(true)
        loginViewModel.updateState(viewInput: .loginButtonDidTap(user: user))
        XCTAssertEqual(loginViewModel.state, .okay)
    }
    func testWrongPassword() {
        let loginViewModel = LoginViewModel(loginDelegate: loginDelegateMock, realmService: realmServiceMock)
        loginDelegateMock.fakeResult = .failure(.wrongPassword)
        loginViewModel.updateState(viewInput: .loginButtonDidTap(user: user))
        XCTAssertEqual(loginViewModel.state, .wrongPassword)
    }

}


class LoginDelegateMock: LoginViewControllerDelegate {
    var fakeResult: Result<Bool, AuthorizationError>!
    func checkCredentials(login: String, password: String, completion: @escaping (Result<Bool, Navigation.AuthorizationError>) -> Void) {
        completion(fakeResult)
    }

    func signUp(login: String, password: String, completion: @escaping (Result<Bool, Navigation.AuthorizationError>) -> Void) {
        completion(fakeResult)
    }
}
class RealmServiceMock: RealmServiceProtocol {
    var fakeFetchUser: User? = nil
    var fakeSaveResult: Bool = true

    func saveUser(user: Navigation.User) -> Bool {
        return fakeSaveResult
    }
    func fetchUser() -> Navigation.User? {
        return fakeFetchUser
    }
    func deleteAll() {}


}
