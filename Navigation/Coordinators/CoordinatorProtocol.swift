//
//  CoordinatorProtocol.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get }
    func start() -> UIViewController
    func addChildCoordinator(_ coordinator: CoordinatorProtocol)
    func removeChildCoordinator(_ coordinator: CoordinatorProtocol)
}

extension CoordinatorProtocol {
    func addChildCoordinator(_ coordinator: CoordinatorProtocol) {}
    func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {}
}
