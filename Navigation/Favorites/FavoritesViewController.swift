//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 18.11.2022.
//

import UIKit
import StorageService
import CoreData
import CoreLocation

final class FavoritesViewController: UIViewController {

    static let cellIdentifier = "Favorites"

    private let newDBService = CDserviceVer3()
    private let locationManager = CLLocationManager()

    private lazy var favoriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: FavoritesViewController.cellIdentifier)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var clearButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(clearButtonTap))
    private lazy var searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTap))
    private lazy var mapButton = UIBarButtonItem(image: UIImage(systemName: "map"), style: .done, target: self, action: #selector(mapButtonTap))

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupUI()

        locationManager.delegate = self

        newDBService.fecthedResultsController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearButton.isEnabled = false
        newDBService.fetchPosts(predicate: nil)
    }

    private func setupNavigation() {
        navigationItem.title = NSLocalizedString("favorites.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [searchButton, clearButton]
        navigationItem.leftBarButtonItem = mapButton
    }

    private func setupUI() {
        self.view.addSubview(favoriteTableView)

        NSLayoutConstraint.activate([
            favoriteTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            favoriteTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            favoriteTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            favoriteTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    @objc private func searchButtonTap() {
        let alertController = UIAlertController(title: NSLocalizedString("favorites.alert.title", comment: ""), message: NSLocalizedString("favorites.alert.message", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("general.ok", comment: ""), style: .default) {_ in
            self.searchButton.isEnabled = false
            self.clearButton.isEnabled = true
            let filterId = alertController.textFields?.first?.text ?? ""
            self.newDBService.fetchPosts(predicate: NSPredicate(format: "author == %@", filterId))

            self.favoriteTableView.reloadData() //???

        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("general.cancel", comment: ""), style: .destructive) {_ in
            self.dismiss(animated: true)
        }
        alertController.addTextField()
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    @objc private func clearButtonTap() {
        self.searchButton.isEnabled = true
        self.clearButton.isEnabled = false
        self.newDBService.fetchPosts(predicate: nil)
        self.favoriteTableView.reloadData() //???
    }

    private func goToMap() {
        let mapViewController = MapViewController()
        mapViewController.locationManager = locationManager
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    @objc private func mapButtonTap() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
//            print("Enable location")
            let alertController = UIAlertController(title: NSLocalizedString("favorites.location.alert.title", comment: ""), message: NSLocalizedString("favorites.location.alert.message", comment: ""), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("general.cancel", comment: ""), style: .destructive))
            self.present(alertController, animated: true)
        case .authorizedAlways, .authorizedWhenInUse:
            goToMap()
        @unknown default:
            print("???")
        }

    }

}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.newDBService.fecthedResultsController?.sections else { return 0 }
        searchButton.isEnabled = sections[section].numberOfObjects > 0
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesViewController.cellIdentifier, for: indexPath) as? PostTableViewCell
        else { return PostTableViewCell() }
        guard let post = self.newDBService.fecthedResultsController?.object(at: indexPath) else {
            return cell
        }
        cell.fillCellFromDb(post: post)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let sections = self.newDBService.fecthedResultsController?.sections else { return nil }
        if sections[section].numberOfObjects == 0 {
            return NSLocalizedString("favorites.tip", comment: "")
        } else { return nil }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: NSLocalizedString("general.delete", comment: "")
        ) { _, _, _ in

            self.newDBService.deletePost(indexPath: indexPath)

        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.favoriteTableView.beginUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
//        print("🍏", type.rawValue)
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }

            self.favoriteTableView.insertRows(at: [newIndexPath], with: .left)
        case .delete:
            guard let indexPath = indexPath else { return }

            self.favoriteTableView.deleteRows(at: [indexPath], with: .right)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }

            self.favoriteTableView.deleteRows(at: [indexPath], with: .right)
            self.favoriteTableView.insertRows(at: [newIndexPath], with: .left)
        case .update:
            guard let indexPath = indexPath else { return }

            self.favoriteTableView.reloadRows(at: [indexPath], with: .fade)
        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.favoriteTableView.endUpdates()
    }

}

extension FavoritesViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            goToMap()
        }
    }

}
