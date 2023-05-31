//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.11.2022.
//

import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {

    private let photo: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.tintColor = .systemGray2
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.contentView.addSubview(self.photo)

        NSLayoutConstraint.activate([
            self.photo.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.photo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.photo.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.photo.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    func fillWith(indexPath: IndexPath) {
        let imageName: String = "i-\(indexPath.row + 1)"
        photo.image = UIImage(named: imageName)

    }

    func fillWith(image: UIImage) {
        photo.image = image
    }

}
