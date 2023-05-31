//
//  InfoViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit

class InfoViewController: UIViewController {

    private let alertButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Alert!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.frame = CGRect(x: 150, y: 50, width: 100, height: 50)
        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("✖︎", for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.frame = CGRect(x: 300, y: 30, width: 40, height: 40)
        return button
    }()

    // iosdt/task-2-1
    private let titleLabel: LabelWithPadding = {
        let label = LabelWithPadding()
        label.backgroundColor = .white
        label.layer.borderWidth = 1
        label.numberOfLines = 0
        label.frame = CGRect(x: 50, y: 120, width: 250, height: 120)
        return label
    }()

    // iosdt/task-2-2
    private let orbitalPeriodLabel: LabelWithPadding = {
        let label = LabelWithPadding()
        label.backgroundColor = .white
        label.layer.borderWidth = 1
        label.text = "Orbital period = N/D"
        label.frame = CGRect(x: 50, y: 260, width: 250, height: 40)
        return label
    }()

    // iosdt/task-2-3*
    private let residentTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.layer.borderWidth = 1
        table.frame = CGRect(x: 10, y: 320, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 420)
        return table
    }()

    private let session = URLSession.shared

    private var planet: Planet?
    private var residents: [Resident] = []

    let alertController = UIAlertController(title: "Внимание", message: "Сообщение", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(alertButton)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(orbitalPeriodLabel)
        view.addSubview(residentTableView)
        titleLabelSetup()
        orbitalPeriodLabelSetup()
        setupGestures()

        addTarget()
        alertAction()
        residentTableView.dataSource = self
    }

    // MARK: - iosdt/task-2-1
    private func titleLabelSetup() {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/25") {
            let task = session.dataTask(with: url) { data, response, error in
                if let data {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data)
                        if let casted = dictionary as? [String: Any] {
                            if let title = casted["title"] as? String {
                                DispatchQueue.main.async {
                                    self.titleLabel.text = title
                                }
                            }
                        }
                    } catch let error {
                        print("🛺 -- ", error)
                    }
                }
            }
            task.resume()
        } else {
            print("Unvalid URL")
        }

    }

    // MARK: - iosdt/task-2-2
    private func orbitalPeriodLabelSetup() {
        if let url = URL(string: "https://swapi.dev/api/planets/1") {
            let task = session.dataTask(with: url) { data, response, error in
                if let data {
                    do {
                        self.planet = try JSONDecoder().decode(Planet.self, from: data)
                        self.residentArrayAppend()
                        DispatchQueue.main.async {
                            self.orbitalPeriodLabel.text = "Orbital period = \(self.planet?.orbitalPeriod ?? "N/D")"
                        }
                    } catch let error {
                        print("🎳 -- ", error)
                    }
                }
            }
            task.resume()
        } else {
            print("Unvalid planet URL")
        }
    }

    // MARK: - iosdt/task-2-3
    private func residentArrayAppend() {
            for resident in self.planet!.residents {
                if let url = URL(string: resident) {
                    let task = self.session.dataTask(with: url) { data, response, error in
                        if let data {
                            do {
                                self.residents.append(try JSONDecoder().decode(Resident.self, from: data))
                                DispatchQueue.main.async {
                                    self.residentTableView.reloadData()
                                }
                            } catch let error {
                                print("🚑 -- ", error)
                            }
                        }
                    }
                    task.resume()
                } else {
                    print("Unvalid resident URL")
                }
            }
    }

    func alertAction() {
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            print("OK")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {_ in
            print("Cancel")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
    }

    private func addTarget() {
        alertButton.addTarget(self, action: #selector(tapOnAlert), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(tapOnExit), for: .touchUpInside)
    }
    @objc
    private func tapOnAlert() {
        self.present(alertController, animated: true)
    }
    @objc
    private func tapOnExit() {
        self.dismiss(animated: true)
    }
    // MARK: - Временный метод принуддительного обновления таблицы по тапу по таблице
    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reloadTable))
        self.residentTableView.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc
    private func reloadTable() {
        residentTableView.reloadData()
    }
    
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "residents")
        cell.textLabel!.text = residents[indexPath.row].name
        return cell
    }

}
