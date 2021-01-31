//
//  GalleryImagesViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-01.
//

import UIKit

class GalleryImagesViewController: UIViewController {
    
    var imageURLs: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let containerView = UIView()
    var collectionView: UICollectionView!

    init(title: String, id: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        downloadGalleryImages(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: containerView.frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        containerView.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.smallPadding)
            make.leading.trailing.bottom.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func downloadGalleryImages(id: String) {
        NetworkManager.shared.getImageGalleryURLs(for: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let urls):
                self.imageURLs = urls
            case .failure(let error):
                print(error.rawValue) // TODO: handle error
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension GalleryImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
        cell.set(imageURL: imageURLs[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension GalleryImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ImageCell
        cell.resetImage()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numVisibleImages = 1.5
        let width = collectionView.frame.size.width / CGFloat(numVisibleImages)
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}
