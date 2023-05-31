//
//  RealmService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func saveUser(user: User) -> Bool
    func fetchUser() -> User?
    func deleteAll()
}

final class RealmService: RealmServiceProtocol {

    var config: Realm.Configuration

    init() {
        // MARK: - мой незащищённый ключ шифрования и его обфускация (не для релиза)
//        let key = "mySecretEncryptionKeyForRealmDataBaseSpecial64symbolLengthNeeded"
//        if let encodeData = key.data(using: .utf8) {
//            let arrayOfHex = encodeData
//                .map { String(format: "0x%02x", $0) }
//            print(arrayOfHex)
//        }

        let coded: [UInt8] = [
            0x6d, 0x79, 0x53, 0x65, 0x63, 0x72, 0x65, 0x74, 0x45, 0x6e, 0x63, 0x72, 0x79, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x4b, 0x65, 0x79, 0x46, 0x6f, 0x72, 0x52, 0x65, 0x61, 0x6c, 0x6d, 0x44, 0x61, 0x74, 0x61, 0x42, 0x61, 0x73, 0x65, 0x53, 0x70, 0x65, 0x63, 0x69, 0x61, 0x6c, 0x36, 0x34, 0x73, 0x79, 0x6d, 0x62, 0x6f, 0x6c, 0x4c, 0x65, 0x6e, 0x67, 0x74, 0x68, 0x4e, 0x65, 0x65, 0x64, 0x65, 0x64
        ]

        let data = Data(coded)

        self.config = Realm.Configuration(encryptionKey: data)
    }



    func saveUser(user: User) -> Bool {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.create(UserRealmModel.self, value: user.keyedValues, update: .all)
//                print("success create")
            }
        return true

        } catch let error {
            print("Realm create \(error)")
                return false
        }
    }

    func fetchUser() -> User? {
        do {
            let realm = try Realm(configuration: config)
            let objects = realm.objects(UserRealmModel.self)
            guard let userRealmModels = Array(objects) as? [UserRealmModel] else { return nil }
            print("Количество юзеров в базе: \(userRealmModels.count)")
            guard !userRealmModels.isEmpty else { return nil }
//            print("Fetching", dump(userRealmModels))
            let user = User(userRealmModel: userRealmModels.last!)
            return user
        } catch let error {
            print("Fetch realm error \(error)")
            return nil
        }
    }

    func deleteAll() {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.deleteAll()
            }
            print("REALM delete all")
        } catch let error {
            print("REALM delete \(error)")
        }
    }


}
