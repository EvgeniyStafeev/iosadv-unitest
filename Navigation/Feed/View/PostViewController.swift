//
//  PostViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.11.2022.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .yellow
        showBarButton()
    }

    func showBarButton() {
        let barButton = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(tapOnInfo))
        self.navigationItem.rightBarButtonItem = barButton
    }
    @objc
    func tapOnInfo() {
        let infoView = InfoViewController()
        present(infoView, animated: true)
    }
}
