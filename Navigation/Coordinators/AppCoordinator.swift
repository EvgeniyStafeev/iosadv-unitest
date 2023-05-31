//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {

    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private let factory: LoginFactory

    init(factory: LoginFactory) {
        self.factory = factory
    }

    func start() -> UIViewController {
        let profileCoordinator = ProfileCoordinator(factory: factory)
//        let feedCoordinator = FeedCoordinator()
        let favoritesCoordinator = FavoritesCoordinator()

        let tabBarController = TabBarController(viewControllers: [
            favoritesCoordinator.start(),
            profileCoordinator.start(),
//            feedCoordinator.start()
        ])
        tabBarController.selectedIndex = 1

        addChildCoordinator(favoritesCoordinator)
        addChildCoordinator(profileCoordinator)
//        addChildCoordinator(feedCoordinator)

        return tabBarController
    }

    func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }


}
