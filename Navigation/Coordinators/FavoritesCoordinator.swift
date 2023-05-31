//
//  FavoritesCoordinator.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit

final class FavoritesCoordinator: CoordinatorProtocol {
    
    var childCoordinators: [CoordinatorProtocol] = []

    func start() -> UIViewController {
        let favoritesViewController = FavoritesViewController()
        let navigationController = UINavigationController.init(rootViewController: favoritesViewController)
        let item = UITabBarItem(title: NSLocalizedString("tabbar.favorites", comment: ""), image:  UIImage(systemName: "checkmark.seal"), tag: 2)
        navigationController.tabBarItem = item
        return navigationController
    }


}
