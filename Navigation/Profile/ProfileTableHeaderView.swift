//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Евгений Стафеев on 26.01.2023.
//

import UIKit

class ProfileTableHeaderView: UIView {

    // MARK: - Properties
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = CGFloat(Constants.avatar / 2)
        view.layer.borderWidth = 3
        view.layer.borderColor = Palette.title.resolvedColor(with: self.traitCollection).cgColor
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.image = UIImage(systemName: "questionmark.circle")
        return view
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: CGFloat(Constants.fullNameFontSize), weight: .bold)
        return label
    }()

    private var statusLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: CGFloat(Constants.statusFontSize), weight: .regular)
        return label
    }()

    private var statusText = ""
    private var statusTextField: TextFieldWithPadding = {
        let tfield = TextFieldWithPadding()
        tfield.backgroundColor = .white
        tfield.layer.cornerRadius = 12
        tfield.layer.borderWidth = 1
        tfield.layer.borderColor = UIColor.black.cgColor
        tfield.textColor = .black
        tfield.font = UIFont.systemFont(ofSize: CGFloat(Constants.setStatusFontSize), weight: .regular)
        tfield.placeholder = NSLocalizedString("profile.statusPlaceholder", comment: "")
        return tfield
    }()

    private let setStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("profile.statusButton", comment: ""), for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .tintColor
        button.layer.cornerRadius = 12
        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 22
        button.layer.borderColor = UIColor.white.cgColor
        button.isHidden = true
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Inits
    override init(frame: CGRect) {

        super.init(frame: frame)
        [fullNameLabel, statusLabel, setStatusButton, statusTextField, backgroundView, avatarImageView, closeButton].forEach(addSubview)
        setupFrames()
        setupConstraints()
        addTarget()
        setupGestures()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    // external configuration method
    func setData(with user: User) {
        fullNameLabel.text = user.userName
        statusLabel.text = user.status
        avatarImageView.image = user.avatar
    }

    private func setupFrames() {
        avatarImageView.frame = CGRect(x: Constants.standartMarggin,
                                       y: Constants.standartMarggin,
                                       width: Constants.avatar,
                                       height: Constants.avatar)
        fullNameLabel.frame = CGRect(x: 2 * Constants.standartMarggin + Constants.avatar,
                                     y: Constants.fullNameTopMargin,
                                     width: Int(UIScreen.main.bounds.width) - (3 * Constants.standartMarggin + Constants.avatar),
                                     height: Constants.fullNameFontSize + 4)
        statusLabel.frame = CGRect(x: 2 * Constants.standartMarggin + Constants.avatar,
                                   y: Constants.standartMarggin + Constants.avatar - Constants.statusBottomMargin - (Constants.statusFontSize + 4),
                                   width: Int(UIScreen.main.bounds.width) - (3 * Constants.standartMarggin + Constants.avatar),
                                   height: Constants.statusFontSize + 4)
        statusTextField.frame = CGRect(x: 2 * Constants.standartMarggin + Constants.avatar - Constants.setStatusLeftPadding,
                                       y:  Constants.standartMarggin + Constants.avatar - Constants.statusBottomMargin + Constants.standartMarggin / 2,
                                       width: Int(UIScreen.main.bounds.width) - (3 * Constants.standartMarggin + Constants.avatar) + Constants.setStatusLeftPadding,
                                       height: Constants.setStatusTFHeight)
        setStatusButton.frame = CGRect(x: Constants.standartMarggin,
                                       y: 3 * Constants.standartMarggin + Constants.avatar,
                                       width: Int(UIScreen.main.bounds.width) - (2 * Constants.standartMarggin),
                                       height: Constants.setStatusBtnHeight)

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -60),
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),

            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func addTarget() {
        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        statusTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
    @objc
    private func buttonPressed() {
        statusLabel.text = statusText
        statusTextField.text = ""
        endEditing(true)
    }
    @objc
    private func statusTextChanged( _textField: UITextField) {
        statusText = statusTextField.text ?? ""
    }

    // обработка жестов
    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc private func tapGesture() {
        animationAvatar()
        avatarImageView.isUserInteractionEnabled = false
        self.superview?.viewWithTag(11)?.isUserInteractionEnabled = false
        ProfileViewController.tableView.isScrollEnabled = false
    }

    private func animationAvatar() {
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.center.x = self.superview!.center.x
            self.avatarImageView.center.y = self.superview!.center.y - 40
            self.avatarImageView.transform = CGAffineTransform(scaleX: UIScreen.main.bounds.width / CGFloat(Constants.avatar),
                                                               y: UIScreen.main.bounds.width / CGFloat(Constants.avatar))
            self.avatarImageView.layer.cornerRadius = 0
            self.avatarImageView.layer.borderWidth = 1
            self.backgroundView.isHidden = false
            self.backgroundView.alpha = 0.7
            UIView.animate(withDuration: 0.3, delay: 0.5) {
                self.closeButton.isHidden = false
                self.closeButton.alpha = 1
            }
        }
    }
    @objc private func closePressed() {
        UIView.animate(withDuration: 0.3) {
            self.closeButton.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.3) {
                self.avatarImageView.center = CGPoint(x: Constants.standartMarggin + Constants.avatar / 2,
                                                      y: Constants.standartMarggin + Constants.avatar / 2)
                self.avatarImageView.transform = .identity
                self.avatarImageView.layer.cornerRadius = CGFloat(Constants.avatar / 2)
                self.avatarImageView.layer.borderWidth = 3
                self.backgroundView.alpha = 0
            }
        }
        self.superview?.viewWithTag(11)?.isUserInteractionEnabled = true
        ProfileViewController.tableView.isScrollEnabled = true
        avatarImageView.isUserInteractionEnabled = true
        closeButton.isHidden = true
        backgroundView.isHidden = true
    }

    // принудительное обновление при смене темы. для слоёв и картинок
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.avatarImageView.layer.borderColor = Palette.title.cgColor

        if UITraitCollection.current.userInterfaceStyle == .dark {
            self.avatarImageView.image = UIImage(systemName: "ant")
        } else {
            self.avatarImageView.image = UIImage(systemName: "ant.fill")
        }
    }

}
