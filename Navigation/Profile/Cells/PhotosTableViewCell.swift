//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.11.2022.
//

import UIKit

final class PhotosTableViewCell: UITableViewCell {

    // MARK: - Properties
    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let photoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.text = NSLocalizedString("profile.photos", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let forwardImage: UIImageView = {
        let forward = UIImageView()
        forward.image = UIImage(systemName: "arrow.forward")
        forward.tintColor = .label
        forward.translatesAutoresizingMaskIntoConstraints = false
        return forward
    }()

    private let photoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.clipsToBounds = true
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var previewImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "i-1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var previewImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "i-2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var previewImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "i-3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var previewImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "i-4")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var timer2 = Timer(timeInterval: 4, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    private var repeatCount = 0

    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.tag = 11

        RunLoop.current.add(timer2, forMode: .common)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    deinit {
//        print(#function)
//        timer2.invalidate()
//    }

    // MARK: - Methods
    private func setupUI() {
        contentView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(photoLabel)
        titleStackView.addArrangedSubview(forwardImage)
        contentView.addSubview(photoStackView)
        [previewImage1, previewImage2, previewImage3, previewImage4].forEach(photoStackView.addArrangedSubview)

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),

            photoStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 12),
            photoStackView.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor),
            photoStackView.trailingAnchor.constraint(equalTo: titleStackView.trailingAnchor),
            photoStackView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 48) / 4),
            photoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    @objc private func changeImage() {
//        print("Timer2")
        self.previewImage1.image = UIImage(named: "i-\(Int.random(in: 1...22))")
        self.previewImage2.image = UIImage(named: "i-\(Int.random(in: 1...22))")
        self.previewImage3.image = UIImage(named: "i-\(Int.random(in: 1...22))")
        self.previewImage4.image = UIImage(named: "i-\(Int.random(in: 1...22))")
        repeatCount += 1
        if repeatCount == 5 {
//            print("Timer2 Invalidate")
            timer2.invalidate()
            // тут я удаляю таймер по счётчику
        }
    }

}
