//
//  FeedModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import Foundation

protocol FeedModelProtocol {
    func check(word: String, completion: @escaping ((Result<Bool, FeedError>) -> Void))
}

final class FeedModel: FeedModelProtocol {

    private let secretWord = "Друг"
    private var isCorrect = false

    // TASK #11-3
    func check(word: String, completion: @escaping ((Result<Bool, FeedError>) -> Void)) {
        guard word != "" else { return }
        if self.secretWord == word {
            completion(.success(true))
        } else {
            completion(.failure(.wrongPass))
        }
    }

}

enum FeedError: Error {
    case wrongPass
}
