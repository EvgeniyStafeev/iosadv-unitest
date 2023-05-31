//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 15.11.2022.
//

import Foundation

protocol LoginViewModelProtocol {
    // output to View
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    // input
    func updateState(viewInput: LoginViewModel.ViewInput)

    // check initial state
    func initialState(sensorType: (String) -> Void)
}

final class LoginViewModel: LoginViewModelProtocol {

    enum State: Equatable {
        case noUser
        case identifiedUser(user: User)
        case invalidEmail
        case wrongPassword
        case unknownUser(newUser: User)
        case registerUser(newUser: User)
        case noBiometry
        case okay
    }
    enum ViewInput {
        case loginButtonDidTap(user: User)
        case registerNewUserDidTap(user: User)
        case loginWithBio
    }

    weak var coordinator: ProfileCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .noUser {
        didSet { //didSet НЕ срабатывает в инициализаторе!!!
            // при изменении состояния передаём стэйт наружу
            onStateDidChange?(state)
        }
    }

    private let realmService: RealmServiceProtocol
    private var loginDelegate: LoginViewControllerDelegate?
    private let localAuthorizationService: LocalAuthorizationService

    init(loginDelegate: LoginViewControllerDelegate, realmService: RealmServiceProtocol, localAuthorizationService: LocalAuthorizationService) {
        self.loginDelegate = loginDelegate
        self.realmService = realmService
        self.localAuthorizationService = localAuthorizationService
    }

    /// дополнительный метод для того чтобы сработал didSet после инициализатора
    func initialState(sensorType: (String) -> Void) {
        let user = realmService.fetchUser()
        if let user {
            self.state = .identifiedUser(user: user)
        } else {
            self.state = .noUser
        }
        sensorType(localAuthorizationService.sensorType)
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .loginButtonDidTap(user: let user):
            self.loginDelegate?.checkCredentials(login: user.userName, password: user.password) { result in
                switch result {
                case .success(true): self.state = .okay; self.loginSuccess(user: user)
                case .failure(.unknowUser): self.state = .unknownUser(newUser: user)
                case .failure(.wrongPassword): self.state = .wrongPassword
                case .failure(.badLoginFormat): self.state = .invalidEmail
                case .success(false): ()
                }
            }
        case .registerNewUserDidTap(user: let user):
            newUser(user: user)
        case .loginWithBio:
            localAuthorizationService.authorizeIfPossible { [weak self] bioResult in
                if bioResult {
                    print("🟢")
                    if let user = self?.realmService.fetchUser() {
                        self?.state = .okay
                        sleep(1)
                        DispatchQueue.main.async {
                            self?.coordinator?.pushProfileVC(userName: user.userName)
                        }
                    }
                } else {
                    print("⛔️")
                    self?.state = .noBiometry
                }
            }
        }
    }
    private func loginSuccess(user: User) {
        let success = realmService.saveUser(user: user)
        if success {
            coordinator?.pushProfileVC(userName: user.userName)
        }
    }
    private func newUser(user: User) {
        self.loginDelegate?.signUp(login: user.userName, password: user.password, completion: { result in
            if result == .success(true) {
                self.loginSuccess(user: user)
            }
        })
    }
}
