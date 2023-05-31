//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 18.11.2022.
//

import Foundation

protocol FeedViewModelProtocol {
//    var state: FeedViewModel.State { get }
    // output to View
    var onStateDidChange: ((FeedViewModel.State) -> Void)? { get set }
    // input
    func updateState(viewInput: FeedViewModel.ViewInput, text: String?)
}

final class FeedViewModel: FeedViewModelProtocol {

    enum State {
        case initial
        case wrongAnswer
        case rightAnswer
        case noAnswer
    }
    enum ViewInput {
        case postButton1DidTap
        case postButton2DidTap
        case guessButtonDidTap
    }

    weak var coordinator: FeedCoordinator?
    var onStateDidChange: ((State) -> Void)?
    var feedModel: FeedModelProtocol = FeedModel()

    private(set) var state: State = .initial {
        didSet {
            // при изменении состояния передаём стэйт наружу
            onStateDidChange?(state)
        }
    }

    
    func updateState(viewInput: ViewInput, text: String?) {
        switch viewInput {
        case .postButton1DidTap:
            coordinator?.pushPostVC()
        case .postButton2DidTap:
            state = .noAnswer
        case .guessButtonDidTap:
            feedModel.check(word: text ?? "") { result in
                switch result {
                case .success(true):
                    self.state = .rightAnswer
                    print("YES")
                case .success(false):
                    print("???")
                case .failure(FeedError.wrongPass):
                    self.state = .wrongAnswer
                    print("NO")
                case .failure(_):
                    ()
                }
            }
        }
    }


}
