//
//  UserRealmModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.01.2023.
//

import Foundation
import RealmSwift

final class UserRealmModel: Object {

    @objc dynamic var userName: String?
    @objc dynamic var status: String?
    @objc dynamic var password: String?

    override class func primaryKey() -> String? {
        return "userName"
    }

    convenience init(user: User) {
        self.init()
        self.userName = user.userName
        self.status = user.status
        self.password = user.password
    }

}
