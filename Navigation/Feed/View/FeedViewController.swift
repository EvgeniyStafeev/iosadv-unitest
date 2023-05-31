//
//  FirstController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit

class FeedViewController: UIViewController {

    private var viewModel: FeedViewModelProtocol

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 10
//        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var guessTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Друг"
        textField.placeholder = "Молви друг и войди!"
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private var indicatorLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .lightGray
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
//        self.title = "Feed"
        setupUI()
        bindViewModel() // MVVM
    }

    private func setupUI() {
        view.addSubview(stackView)
        let postButton = CustomButton(title: " POST ", colorTitle: .black, bgdColor: .systemGray6, corneR: 1, action: post1Pressed)
        let postButton2 = CustomButton(title: " POST number 2 ", colorTitle: .white, bgdColor: .systemOrange, corneR: 5, action: post2Pressed)
        stackView.addArrangedSubview(postButton)
        stackView.addArrangedSubview(postButton2)
        view.addSubview(guessTextField)
        let guessButton = CustomButton(title: "Войти", colorTitle: .white, bgdColor: .darkGray, corneR: 8, action: guessButtonTap)
        view.addSubview(guessButton)
        view.addSubview(indicatorLabel)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            stackView.widthAnchor.constraint(equalToConstant: 150),
            guessTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guessTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            guessTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            guessTextField.heightAnchor.constraint(equalToConstant: 35),
            guessButton.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 16),
            guessButton.centerXAnchor.constraint(equalTo: guessTextField.centerXAnchor),
            guessButton.widthAnchor.constraint(equalToConstant: 100),
            guessButton.heightAnchor.constraint(equalToConstant: 44),
            indicatorLabel.trailingAnchor.constraint(equalTo: guessTextField.trailingAnchor),
            indicatorLabel.topAnchor.constraint(equalTo: guessButton.topAnchor),
            indicatorLabel.bottomAnchor.constraint(equalTo: guessButton.bottomAnchor),
            indicatorLabel.widthAnchor.constraint(equalTo: indicatorLabel.heightAnchor)
        ])
    }

    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {

            case .initial:
                self.indicatorLabel.backgroundColor = .clear
            case .wrongAnswer:
                self.indicatorLabel.backgroundColor = .red
            case .rightAnswer:
                self.indicatorLabel.backgroundColor = .green
            case .noAnswer:
                self.indicatorLabel.backgroundColor = .systemYellow
            }
        }
    }

    // Новый красивый компактный метод
    private func post1Pressed() {
        viewModel.updateState(viewInput: .postButton1DidTap, text: nil)
    }
    private func post2Pressed() {
        viewModel.updateState(viewInput: .postButton2DidTap, text: nil)
    }
    private func guessButtonTap() {
        viewModel.updateState(viewInput: .guessButtonDidTap, text: guessTextField.text)
    }

    
}

// Hide keyboard by return button
extension FeedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guessTextField.resignFirstResponder()
    }
}
