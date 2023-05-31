//
//  NetworkService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 26.01.2023.
//

import Foundation

enum AppConfiguration: String {
    case lukeSkywalker = "https://swapi.dev/api/people/1"
    case darthVader = "https://swapi.dev/api/people/4"
    case obiWanKenobi = "https://swapi.dev/api/people/10"
}

struct NetworkService {

    static func request(for configuration: AppConfiguration) {

        let url = URL(string: configuration.rawValue)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { data, response, error in
            guard let data, error == nil else {
//                print("\n___________________\n")
//                print(error.debugDescription)
                return
            }
            if let _ = try? JSONDecoder().decode(Hero.self, from: data) {
//                print(hero.presenting())
            } else {
//                print("Decoding fail")
            }
//            if let response = response as? HTTPURLResponse {
//                print("\n___________________\n")
//                print(response.allHeaderFields)
//                print("Response Status:", response.statusCode)
//            }
        }
        task.resume()

    }

}


// MARK: - Hero
struct Hero: Codable {
    let name, height, mass, hairColor: String
    let skinColor, eyeColor, birthYear, gender: String

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender
    }

    func presenting() -> String {
        """
Name: \(name)
Birth year: \(birthYear)
Gender: \(gender)
Height: \(height), Mass: \(mass)
Hair color: \(hairColor), Eye color: \(eyeColor)
"""
    }

}
