//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit

final class ProfileCoordinator: CoordinatorProtocol {

    private let factory: LoginFactory
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private var vc: UINavigationController?

    init(factory: LoginFactory) {
        self.factory = factory
    }

    func start() -> UIViewController {
        let realmService = RealmService()
        let loginInspector = factory.makeLoginInspector()
        let localAuthorizationService = LocalAuthorizationService()
        let loginViewModel = LoginViewModel(loginDelegate: loginInspector, realmService: realmService, localAuthorizationService: localAuthorizationService)
        loginViewModel.coordinator = self
        let loginViewController = LoginViewController(viewModel: loginViewModel)
//        loginViewController.loginDelegate = loginInspector
        let navigationController = UINavigationController.init(rootViewController: loginViewController)
        let item = UITabBarItem(title: NSLocalizedString("tabbar.profile", comment: ""), image:  UIImage(systemName: "person.circle"), tag: 1)
        navigationController.tabBarItem = item
        self.vc = navigationController
        return navigationController
    }

    func pushProfileVC(userName: String) {
        let profileVC = ProfileViewController(currentUser: User(userName: userName, password: ""))
        vc?.setViewControllers([profileVC], animated: true)
    }

}
