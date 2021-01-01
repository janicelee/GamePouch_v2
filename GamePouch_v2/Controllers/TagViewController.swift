//
//  TagViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-28.
//

import UIKit

class TagViewController: UIViewController {
    
    let titleText: String
    let tags: [String]
    
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let containerView = UIView()
    var collectionView: TagCollectionView!
    
    init(title: String, tags: [String]) {
        self.titleText = title
        self.tags = tags
        super.init(nibName: nil, bundle: nil)
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
        
        titleLabel.text = titleText
        
        let flowLayout = TagCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 6
        
        collectionView = TagCollectionView(frame: containerView.frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        containerView.addSubview(collectionView)
        
        let verticalPadding: CGFloat = 8
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(verticalPadding)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension TagViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as! TagCell
        cell.setLabel(to: tags[indexPath.row])
        return cell
    }
}

extension TagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = tags[indexPath.row]
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15)]).width + 26
        let height = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15)]).height + 10
        return CGSize(width: width, height: height)
    }
}