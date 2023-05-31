//
//  SecondController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 26.01.2023.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController {

    let currentUser: User
    static let cellIdentifier = "PostTableViewCell"

    static var tableView: UITableView = {
        let tView = UITableView()
        #if DEBUG
        tView.backgroundColor = .systemYellow
        #else
        tView.backgroundColor = Palette.userHeader
        #endif
        tView.showsVerticalScrollIndicator = false
        tView.register(PostTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.dragInteractionEnabled = true
        return tView
    }()

    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(Self.tableView)
        let profileTHV = ProfileTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
        profileTHV.setData(with: currentUser)
        Self.tableView.tableHeaderView = profileTHV
        Self.tableView.dataSource = self
        Self.tableView.delegate = self
        Self.tableView.dragDelegate = self
        Self.tableView.dropDelegate = self

        setup()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        Self.tableView.reloadData()
    }

    private func setup() {
        NSLayoutConstraint.activate([
            Self.tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            Self.tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            Self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            Self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

// MARK: - Extensions
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return postArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = PhotosTableViewCell()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewController.cellIdentifier, for: indexPath) as? PostTableViewCell
            else {return PostTableViewCell()}
            cell.fillData(with: postArray, indexPath: indexPath)
            return cell

        }
    }

    // количество сеций (Фото + Посты)
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    // отрисовка маленькой перемычки между секциями с помощью футера с пустым тайтлом
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return (section == 0 ? " " : nil)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: [0, 0], animated: true)
        if indexPath == [0, 0] {
            navigationController?.pushViewController(PhotosViewController(), animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }

}

// Drag'n'Drop
extension ProfileViewController: UITableViewDragDelegate, UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.section == 1 {
            return [
                UIDragItem(itemProvider: NSItemProvider(object: postArray[indexPath.row].image)),
                UIDragItem(itemProvider: NSItemProvider(object: NSString(string: postArray[indexPath.row].article)))
            ]
        } else {
            return []
        }
    }


    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: String.self)

    }
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        UITableViewDropProposal(operation: .copy)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {

        let dropPost = Post(id: 99, author: "Drag&Drop", article: "", image: UIImage(systemName: "questionmark.app")!, likes: 0, views: 0)

        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Последний индекс таблицы
            let row = tableView.numberOfRows(inSection: 1)
            destinationIndexPath = IndexPath(row: row, section: 1)
        }

        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            guard let imageItem = items.first as? UIImage else { return }
            dropPost.image = imageItem
        }
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let textItem = items.first as? String else { return }
            dropPost.article = textItem
        }

//        Self.tableView.reloadData()
        Self.tableView.beginUpdates()
        postArray.insert(dropPost, at: destinationIndexPath.row)
        Self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
        Self.tableView.endUpdates()

    }


}
