//
//  Post.swift
//  Navigation
//
//  Created by Евгений Стафеев on 18.11.2022.
//

import UIKit

public class Post {

    public var id: Int32
    public var author: String
    public var article: String
    public var image: UIImage
    public var imageName: String
    public var likes: Int32
    public var views: Int32
//    public var isFavorite: Bool = false

    init(id: Int32, author: String, article: String, image: UIImage, likes: Int32, views: Int32) {
        self.id = id
        self.author = author
        self.article = article
        self.image = image
        self.imageName = ""
        self.likes = likes
        self.views = views
    }

    init(postCoreDataModel: PostCoreDataModel) {
        self.id = postCoreDataModel.id
        self.author = postCoreDataModel.author ?? ""
        self.article = postCoreDataModel.article ?? ""
        self.image = UIImage(named: postCoreDataModel.image!) ?? UIImage(systemName: "questionmark.app")!
        self.imageName = ""
        self.likes = postCoreDataModel.likes
        self.views = postCoreDataModel.views
    }

}

let post1 = Post(id: 29365, author: "sport.express", article: """
                 Фавориты ЧМ-2022 по футболу: Бразилия или Португалия? Расклады чемпионата мира 2022
                 Бразилия — главный фаворит, последний шанс Месси, Португалия всех удивит? Расклады ЧМ-2022
                 """, image: UIImage(named: "worldcup")!, likes: 134, views: 200)

let post2 = Post(id: 59769, author: "autonews.ru", article: """
                10 крутых автоновинок, которые стоит ждать в России в 2023 году
                Китайский двойник Porsche Panamera, кроссовер в стиле советской «Победы», внедорожник на базе Peugeot из Ирана и другие интересные новинки, которые уже в скором времени могут добраться до России

                Подробнее на Autonews:
                https://www.autonews.ru/news/
                """, image: UIImage(named: "autonews")!, likes: 56, views: 151)

let post3 = Post(id: 854876, author: "Новости кино", article: """
                Хронометраж фильма «Аватар: Путь воды» (Avatar: The Way of Water) составит около 3 часов и 10 минут — такой информацией делится издание The Hollywood Reporter со ссылкой на собственные источники. Первый «Аватар», релиз которого состоялся в 2009 году, длился чуть больше 2 часов и 40 минут. Таким образом THR подтверждает намёки Джеймса Кэмерона о том, что сиквел будет идти дольше трёх часов.
                """, image: UIImage(named: "avatar2")!, likes: 999, views: 1888)

let post4 = Post(id: 96245, author: "vc.ru", article: """
                Выбрали популярные подборки пользователей и материалы редакции о нейросетях, которые могут по текстовому запросу отредактировать изображение, нарисовать новое, «придумать» к нему описание, «раскрасить» чёрно-белую картинку и другое
                """, image: UIImage(named: "neuro")!, likes: 268, views: 666)

let post5 = Post(id: 98765, author: "qwerty", article: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
                """, image: UIImage(named: "leopold")!, likes: 0, views: 1)

let post6 = Post(id: 76588, author: "Павел", article: "Моя кошка Плюша", image: UIImage(named: "cat")!, likes: 99, views: 99)

public var postArray: [Post] = [post1, post2, post3, post4, post5, post6]

