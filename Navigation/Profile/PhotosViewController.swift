//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.11.2022.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {

    // MARK: - Properties
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()

    private lazy var photoCollectionView: UICollectionView = {
        let cV = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        cV.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCell")
        cV.backgroundColor = Palette.appBackground
        cV.dataSource = self
        cV.delegate = self
        cV.translatesAutoresizingMaskIntoConstraints = false
        return cV
    }()

    let itemCount = 22
    let imageProcessor = ImageProcessor()
    var myCats: [UIImage] = []

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        (1...itemCount).forEach {myCats.append(UIImage(named: "i-\( $0 )")!)}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = Palette.appBackground

        navigationController?.navigationBar.isHidden = false
        navigationItem.title = NSLocalizedString("profile.photogallery", comment: "")
        navigationController?.hidesBarsOnSwipe = true

        setupUI()

//        let startTime = Date().timeIntervalSince1970 // начало отсчёта времени
        // преобразуем исходные изображения с помощью фильтра imageProcessor
        imageProcessor.processImagesOnThread(sourceImages: myCats, filter: .colorInvert, qos: .userInteractive) { filterCats in
            for (ind, _) in self.myCats.enumerated() {
                self.myCats[ind] = UIImage(cgImage: filterCats[ind]!)
            }
            DispatchQueue.main.async {
//                let endTime = Date().timeIntervalSince1970 // конец отсчёта времени
                self.photoCollectionView.reloadData()
//                print(endTime - startTime)
            }
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Methods
    private func setupUI() {
        view.addSubview(photoCollectionView)

        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

        ])
    }
}

// MARK: - Extensions
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myCats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as? PhotosCollectionViewCell
        else { return PhotosCollectionViewCell() }

        cell.fillWith(image: myCats[indexPath.item])
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - 32) / 3
        return CGSize(width: itemWidth, height: itemWidth * 0.7)
    }
 
}
