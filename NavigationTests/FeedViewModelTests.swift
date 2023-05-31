//
//  FeedViewModelTests.swift
//  NavigationTests
//
//  Created by Евгений Стафеев on 17.05.2023.
//

import Foundation
import XCTest
@testable import Navigation

class FeedViewModelTests: XCTestCase {

    var feedModelMock = FeedModelMock()
    var feedViewModel = FeedViewModel()

    // проверяю результат через вьюимпут, не подменяю feedModel на Mock
    func testSuccessResult() {
        feedViewModel.updateState(viewInput: .guessButtonDidTap, text: "Друг")
        XCTAssertEqual(feedViewModel.state, .rightAnswer)
    }
    func testFailureResult() {
        // подменяю модель на моковую
        feedViewModel.feedModel = feedModelMock
        // подставляю результат (fail)
        feedModelMock.fakeResult = .failure(.wrongPass)
        // но чтобы у viewModel изменился State приходится всё равно дёергать вьюимпут с любым текстом
        feedViewModel.updateState(viewInput: .guessButtonDidTap, text: "Друг")
        
        XCTAssertEqual(feedViewModel.state, .wrongAnswer)
    }
    func testYellowState() {
        feedViewModel.updateState(viewInput: .postButton2DidTap, text: nil)
        XCTAssertEqual(feedViewModel.state, .noAnswer)
    }
}

class FeedModelMock: FeedModelProtocol {
    var fakeResult: Result<Bool, FeedError>!
    func check(word: String, completion: @escaping ((Result<Bool, FeedError>) -> Void)) {
        completion(fakeResult)
    }
}
