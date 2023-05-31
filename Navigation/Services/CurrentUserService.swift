//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.01.2023.
//

import UIKit

protocol UserService: AnyObject {
    func userService(checking: Bool) -> User?
}

final class CurrentUserService: UserService {

    let user = User(userName: "Evgeny Stafeev",
                    password: "",
                    avatar: UIImage(named: "Фото11") ?? UIImage(systemName: "questionmark.circle")!,
                    status: "Учусь в Нетологии")

    func userService(checking: Bool) -> User? {
        checking ? user : nil
    }

}
