//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit

final class FeedCoordinator: CoordinatorProtocol {

    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private var vc: UINavigationController?

    func start() -> UIViewController {
        let feedModel = FeedViewModel()
        let feedViewController = FeedViewController(viewModel: feedModel)
        let navigationController = UINavigationController.init(rootViewController: feedViewController)
        let item = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 0)
        navigationController.tabBarItem = item
        self.vc = navigationController
        feedModel.coordinator = self
        return navigationController
    }

    func pushPostVC() {
//        print("b1-3 (Push VC)")
        let postViewController = PostViewController()

        vc?.pushViewController(postViewController, animated: true)
    }


}
