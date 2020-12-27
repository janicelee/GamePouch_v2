//
//  GameInfoViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-18.
//

import UIKit
import SnapKit

class GameInfoViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let headerImageView = GameImageView(frame: .zero)
    
    let largeIconView = UIView()
    let ratingIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rating)
    let rankIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rank)
    
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let yearLabel = UILabel()
    
    let rowStackView = UIStackView()
    let playersIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.players)
    let timeIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.time)
    let difficultyIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.difficulty)
    let ageIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.age)
    
    let descriptionLabel = UILabel()
    
    let galleryImagesTitleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let galleryImagesContainerView = UIView()
    var galleryImagesCollectionView: UICollectionView!
    
    let categoriesTitleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let categoriesContainerView = UIView()
    var categoriesCollectionView: TagCollectionView!
    
    let mechanicsTitleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let mechanicsContainerView = UIView()
    var mechanicsCollectionView: TagCollectionView!
    
    let edgePadding: CGFloat = 20
    let verticalPadding: CGFloat = 8
    
    var game: Game!
    var descriptionExpanded = false
    var galleryImageURLs: [String] = []
    
    init(game: Game) {
        super.init(nibName: nil, bundle: nil)
        self.title = nil
        self.game = game
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        ratingIconGroup.label.text = game.getRating()
        setRankText(rank: game.getRank())
        titleLabel.text = game.getTitle()
        yearLabel.text = game.getYearPublished()
        playersIconGroup.label.text = "\(game.getNumPlayers())\nPlayers"
        timeIconGroup.label.text = "\(game.getPlayTime())\nMinutes"
        difficultyIconGroup.label.text = "\(game.getDifficulty())\nDifficulty"
        ageIconGroup.label.text = "\(game.getMinAge())\nYears"
        descriptionLabel.text = game.getDescription()
        galleryImagesTitleLabel.text = "Images"
        categoriesTitleLabel.text = "Categories"
        mechanicsTitleLabel.text = "Mechanics"
        
        if let imageURL = game.imageURL {
            headerImageView.setImage(from: imageURL)
        }
        downloadGalleryImages()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        configureHeaderImageView()
        configureLargeIconView()
        configureTitleLabels()
        configureRowStackView()
        configureDescriptionLabel()
        configureGalleryImagesCollectionView()
        configureCategoriesSection()
        configureMechanicsSection()
    }
    
    private func configureHeaderImageView() {
        scrollView.addSubview(headerImageView)
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view)
            make.height.equalTo(300)
        }
    }
    
    private func configureLargeIconView() {
        scrollView.addSubview(largeIconView)
        [ratingIconGroup, rankIconGroup].forEach { largeIconView.addSubview($0) }
        
        largeIconView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview()
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(20)
            make.centerY.equalTo(ratingIconGroup.snp.centerY)
        }
    }
    
    private func configureTitleLabels() {
        [titleLabel, yearLabel].forEach { scrollView.addSubview($0) }
        
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9

        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        yearLabel.textColor = .secondaryLabel
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(largeIconView.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(edgePadding + 2)
            make.trailing.equalTo(view)
        }
    }
    
    private func configureRowStackView() {
        scrollView.addSubview(rowStackView)
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach { rowStackView.addArrangedSubview($0)
        }
        
        rowStackView.backgroundColor = .systemBackground
        rowStackView.distribution = .fillEqually
        
        playersIconGroup.label.numberOfLines = 2
        timeIconGroup.label.numberOfLines = 2
        difficultyIconGroup.label.numberOfLines = 2
        ageIconGroup.label.numberOfLines = 2
        
        rowStackView.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(8)
            make.trailing.equalTo(view).offset(-8)
        }
    }
    
    private func configureDescriptionLabel() {
        scrollView.addSubview(descriptionLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 6
        descriptionLabel.lineBreakMode = .byTruncatingTail
        
        descriptionLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        descriptionLabel.addGestureRecognizer(tapGesture)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(rowStackView.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
        }
    }
    
    private func configureGalleryImagesCollectionView() {
        scrollView.addSubview(galleryImagesTitleLabel)
        scrollView.addSubview(galleryImagesContainerView)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        galleryImagesCollectionView = UICollectionView(frame: galleryImagesContainerView.frame, collectionViewLayout: flowLayout)
        galleryImagesCollectionView.delegate = self
        galleryImagesCollectionView.dataSource = self
        galleryImagesCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        galleryImagesCollectionView.backgroundColor = .systemBackground
        galleryImagesContainerView.addSubview(galleryImagesCollectionView)

        galleryImagesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
        }
        
        galleryImagesContainerView.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
            make.top.equalTo(galleryImagesTitleLabel.snp.bottom).offset(verticalPadding)
            make.height.equalTo(160)
        }
        
        galleryImagesCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureCategoriesSection() {
        scrollView.addSubview(categoriesTitleLabel)
        scrollView.addSubview(categoriesContainerView)
        
        let flowLayout = TagCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 6
        
        categoriesCollectionView = TagCollectionView(frame: categoriesContainerView.frame, collectionViewLayout: flowLayout)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseID)
        categoriesCollectionView.backgroundColor = .systemBackground
        categoriesContainerView.addSubview(categoriesCollectionView)
        
        categoriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(galleryImagesContainerView.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
        }
        
        categoriesContainerView.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
            make.top.equalTo(categoriesTitleLabel.snp.bottom).offset(verticalPadding)
        }
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureMechanicsSection() {
        scrollView.addSubview(mechanicsTitleLabel)
        scrollView.addSubview(mechanicsContainerView)
        
        let flowLayout = TagCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 6
        
        mechanicsCollectionView = TagCollectionView(frame: mechanicsContainerView.frame, collectionViewLayout: flowLayout)
        mechanicsCollectionView.delegate = self
        mechanicsCollectionView.dataSource = self
        mechanicsCollectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseID)
        mechanicsCollectionView.backgroundColor = .systemBackground
        mechanicsContainerView.addSubview(mechanicsCollectionView)
        
        mechanicsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoriesContainerView.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
        }
        
        mechanicsContainerView.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
            make.top.equalTo(mechanicsTitleLabel.snp.bottom).offset(verticalPadding)
            make.bottom.equalToSuperview()
        }
        
        mechanicsCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func downloadGalleryImages() {
        guard let id = game.id else { return }
        
        NetworkManager.shared.getImageGalleryURLs(for: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let urls):
                self.galleryImageURLs = urls
                DispatchQueue.main.async {
                    self.galleryImagesCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        if descriptionExpanded {
            descriptionLabel.numberOfLines = 6
            descriptionLabel.lineBreakMode = .byTruncatingTail
        } else {
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
        }
        descriptionExpanded = !descriptionExpanded
    }
    
    private func setRankText(rank: String) {
        rankIconGroup.label.text = rank
        guard rank != "N/A" else { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        if let rankInt = Int(rank) {
            let rankNSNumber = NSNumber(value: rankInt)
            guard var result = formatter.string(from: rankNSNumber) else { return }
            result = result.replacingOccurrences(of: ",", with: "")
            
            let font: UIFont? = UIFont.systemFont(ofSize: 15, weight: .bold)
            let fontSuper: UIFont? = UIFont.systemFont(ofSize: 10, weight: .bold)
            let attString: NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
            let location = result.count - 2
            
            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location: location, length:2))
            rankIconGroup.label.attributedText = attString
        }
    }
}

extension GameInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == galleryImagesCollectionView {
            return galleryImageURLs.count
        } else if collectionView == categoriesCollectionView {
            return game.categories.count
        } else {
            return game.mechanics.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == galleryImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
            cell.set(imageURL: galleryImageURLs[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as! TagCell
            let label = (collectionView == categoriesCollectionView) ? game.categories[indexPath.row] : game.mechanics[indexPath.row]
            cell.setLabel(to: label)
            return cell
        }
    }
}

extension GameInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == galleryImagesCollectionView {
            let numVisibleImages = 1.5
            let width = (collectionView.frame.size.width / CGFloat(numVisibleImages))
            let height = collectionView.frame.size.height
            return CGSize(width: width, height: height)
        } else if collectionView == categoriesCollectionView || collectionView == mechanicsCollectionView {
            let text = (collectionView == categoriesCollectionView) ? game.categories[indexPath.row] : game.mechanics[indexPath.row]
            let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15)]).width + 26
            let height = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15)]).height + 10
            return CGSize(width: width, height: height)
        } else {
            print("Unhandled collection view flow layout item size")
            return CGSize(width: 0, height: 0)
        }
    }
}
