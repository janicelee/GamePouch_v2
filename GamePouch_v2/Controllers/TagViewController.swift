//
//  TagViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-28.
//

import UIKit

class TagViewController: UIViewController {
    
    let tags: [String]
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let tagBorderColor: UIColor
    let containerView = UIView()
    var collectionView: TagCollectionView!
    
    init(title: String, tags: [String], borderColor: UIColor) {
        self.tags = tags
        titleLabel.text = title
        tagBorderColor = borderColor
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
        
        let flowLayout = TagCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 6
        
        collectionView = TagCollectionView(frame: containerView.frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseID)
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
}

extension TagViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as! TagCell
        cell.setLabel(to: tags[indexPath.row], borderColor: tagBorderColor)
        return cell
    }
}

extension TagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let text = tags[indexPath.row]
        var width = text.size(withAttributes: [.font: TagCell.font]).width + (TagCell.horizontalPadding * 2) + 1
        let height = text.size(withAttributes: [.font: TagCell.font]).height + (TagCell.verticalPadding * 2) + 1

        let collectionViewWidth = collectionView.frame.size.width
        width = (width <= collectionViewWidth) ? width : collectionViewWidth
        return CGSize(width: width, height: height)
    }
}
