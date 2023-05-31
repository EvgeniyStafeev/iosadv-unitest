//
//  User.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.01.2023.
//

import UIKit

class User: Equatable {

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userName == rhs.userName
    }

    var userName: String
    var password: String
    var avatar: UIImage
    var status: String

    var keyedValues: [String: Any] {
        [
            "userName": self.userName,
            "password": self.password,
            "status": self.status
        ]
    }


    init(userName: String, password: String, avatar: UIImage, status: String) {
        self.userName = userName
        self.password = password
        self.avatar = avatar
        self.status = status
    }
    init(userName: String, password: String) {
        self.userName = userName
        self.password = password
        self.avatar = UIImage(systemName: "person.fill")!
        self.status = ""
    }
    init(userRealmModel: UserRealmModel) {
        self.userName = userRealmModel.userName ?? "??"
        self.password = userRealmModel.password ?? "12345678"
        self.avatar = UIImage(systemName: "person.fill")!
        self.status = userRealmModel.status ?? "?? ?? ??"
    }

}
