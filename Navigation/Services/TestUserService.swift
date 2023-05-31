//
//  TestUserService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 26.01.2023.
//

import UIKit

final class TestUserService: UserService {

    let testUser = User(userName: "Evgeny Stafeev",
                        password: "Qw2",
                        avatar: UIImage(systemName: "Фото5")!,
                        status: "Учусь в Нетологии")

    func userService(checking: Bool) -> User? {
        checking ? testUser : nil
    }

}
