//
//  LoginViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 15.11.2022.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: LoginViewModelProtocol

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.backgroundColor = .systemGray6
        view.distribution = .fillProportionally
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loginTextField: TextFieldWithPadding = {
        let login = TextFieldWithPadding()
        login.placeholder = NSLocalizedString("login.email", comment: "")
        login.keyboardType = .emailAddress
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.tag = 0
        login.returnKeyType = .continue
        login.delegate = self
        return login
    }()

    private let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    private lazy var passwordTextField: TextFieldWithPadding = {
        let password = TextFieldWithPadding()
        password.placeholder = NSLocalizedString("login.password", comment: "")
        password.isSecureTextEntry = true
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.tag = 1
        password.returnKeyType = .done
        password.delegate = self
//        password.rightView = activityIndicator
        password.rightViewMode = .always
        return password
    }()

    private lazy var loginButton: LoginButton = {
        let button = LoginButton()
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        button.setTitle(NSLocalizedString("login.button", comment: ""), for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapOnBtn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bioLoginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "faceid"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(bioTapBtn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let debugAlarm: UILabel = {
        let label = UILabel()
        label.text = "DEBUG"
        label.textColor = .systemRed
        label.alpha = 0.6
        label.font = UIFont.systemFont(ofSize: 100, weight: .heavy)
#if !DEBUG
        label.isHidden = true
#endif
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timer = Timer(timeInterval: 30, target: self, selector: #selector(setupAnimation), userInfo: nil, repeats: true)

    // MARK: - INIT
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        view.backgroundColor = Palette.appBackground
        view.addSubview(scrollView)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(bioLoginButton)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(lineView)
        stackView.addArrangedSubview(passwordTextField)

        scrollView.addSubview(debugAlarm)
        debugAlarm.transform = .init(rotationAngle: .pi/6)

        constraints()
        setupGestures()

        bindViewModel()
        viewModel.initialState { sensorType in
            bioLoginButton.setBackgroundImage(UIImage(systemName: sensorType), for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        print(#function)
        // Добавление таймера в главный RunLoop
        RunLoop.current.add(timer, forMode: .common)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate() // отключение таймера
        // секция ТабБарКонтроллера не удаляется из памяти при переходе на первую секцию
    }

    //  MARK: - Methods
    private func constraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            logoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 100),

            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loginButton.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            bioLoginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            bioLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            bioLoginButton.widthAnchor.constraint(equalToConstant: 50),
            bioLoginButton.heightAnchor.constraint(equalToConstant: 50),

            debugAlarm.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -20),
            debugAlarm.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func bindViewModel() {
        print("--------")
        viewModel.onStateDidChange = { [weak self] state in
            guard let self else {
                print("???????\n")
                return
            }
            switch state {
            case .noUser:
                self.loginButton.isEnabled = false
                self.loginButton.isSelected = true
                self.bioLoginButton.isEnabled = false
                self.bioLoginButton.tintColor = .systemGray5
            case let .identifiedUser(user):
                self.loginTextField.text = user.userName
//                self.passwordTextField.text = user.password // отключил автозаполнение пароля т.к. есть биометрия
                self.loginButton.isEnabled = true
                self.loginButton.isSelected = false
                self.bioLoginButton.isEnabled = true
                self.bioLoginButton.tintColor = .systemGray
            case .invalidEmail:
                self.alerting(title: NSLocalizedString("general.error", comment: ""), message: NSLocalizedString("login.badEmail", comment: ""))
            case .wrongPassword:
                self.alerting(title: NSLocalizedString("general.attention", comment: ""), message: NSLocalizedString("login.wrongPassword", comment: ""))
            case .unknownUser(newUser: let newUser):
                self.alerting(title: NSLocalizedString("login.hello", comment: ""), message: NSLocalizedString("general.register", comment: "") + "\n\(newUser.userName)", signUp: true)
            case .registerUser(newUser: let newUser):
                self.viewModel.updateState(viewInput: .registerNewUserDidTap(user: newUser))
            case .noBiometry:
                self.alerting(title: "Error", message: "No biometry")
            case .okay:
                DispatchQueue.main.async {
                    self.bioLoginButton.tintColor = .systemBlue
                }
            }
        }
    }

    private func alerting(title: String, message: String, signUp: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if signUp {
            alert.addAction(UIAlertAction(title: NSLocalizedString("general.yes", comment: ""), style: .default, handler: { _ in
                // регистрация нового юзера
                self.viewModel.updateState(viewInput: .registerNewUserDidTap(user: User(userName: self.loginTextField.text!, password: self.passwordTextField.text!)))
            }))
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("general.cancel", comment: ""), style: .cancel))
        self.present(alert, animated: true)
    }


    // MARK: Login button func
    @objc private func tapOnBtn() {
        self.viewModel.updateState(viewInput: .loginButtonDidTap(user: User(userName: self.loginTextField.text!, password: self.passwordTextField.text!)))
    }

    @objc private func bioTapBtn() {
        viewModel.updateState(viewInput: .loginWithBio)
    }
    
    //  MARK: hide keyboard by tap
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapHideKbd))
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func viewTapHideKbd() {
        view.endEditing(true)
        scrollView.setContentOffset(.zero, animated: true)
    }

    //  MARK: content offset
    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let bottomButtonY = loginButton.frame.origin.y + loginButton.frame.height
            let offset = UIScreen.main.bounds.height - kbdSize.height - bottomButtonY - 60
            if offset < 0 {
                scrollView.contentOffset = CGPoint(x: 0, y: -offset)
            }
        }
    }
    @objc private func kbdHide(notification: NSNotification) {
        viewTapHideKbd()
    }

    // MARK: Animation
    @objc private func setupAnimation() {
//        print("TIMER")
        UIView.animate(withDuration: 1.2, delay: 0, options: .autoreverse) {
            self.logoImageView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        } completion: { _ in
            self.logoImageView.transform = .identity
        }
    }

}

// MARK: - Extensions

extension LoginViewController: UITextFieldDelegate {
    // скрывать кнопку ЛогИн при пустых полях
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !loginTextField.text!.isEmpty && passwordTextField.text!.count > 5 {
            loginButton.isEnabled = true
            loginButton.isSelected = false
        } else {
            loginButton.isEnabled = false
        }
    }
    // реакция на кнопку return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
            return true
        } else {
            viewTapHideKbd()
            return true
        }
    }

}
