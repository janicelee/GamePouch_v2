//
//  GameInfoViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-18.
//

import UIKit
import SnapKit

class GameInfoViewController: UIViewController {
    
    let stackView = UIStackView()
    let descriptionLabel = UILabel()
    var galleryImagesCollectionView: UICollectionView!
    
    let edgePadding: CGFloat = 20
    let verticalPadding: CGFloat = 8
    
    var game: Game!
    var descriptionExpanded = false
    var galleryImageURLs: [String] = []
    
    init(game: Game) {
        super.init(nibName: nil, bundle: nil)
        self.game = game
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        configure()
        downloadGalleryImages()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        let scrollView = UIScrollView()
        
        stackView.backgroundColor = .systemBackground
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = verticalPadding
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        configureHeaderImageView()
        configureLargeIconView()
        configureTitleLabel()
        configureYearLabel()
        configureRowStackView()
        configureDescriptionLabel()
        configureGalleryImagesTitleLabel()
        configureGalleryImagesContainerView()
        configureCategoriesSection()
        configureMechanicsSection()
    }
    
    private func configureHeaderImageView() {
        let headerImageView = GameImageView(frame: .zero)
        stackView.addArrangedSubview(headerImageView)
        
        headerImageView.layer.cornerRadius = 0
        
        if let imageURL = game.imageURL {
            headerImageView.setImage(from: imageURL)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(300)
        }
    }
    
    private func configureLargeIconView() {
        let largeIconView = UIView()
        let ratingIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rating)
        let rankIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rank)
        
        stackView.addArrangedSubview(largeIconView)
        [ratingIconGroup, rankIconGroup].forEach { largeIconView.addSubview($0) }
        
        ratingIconGroup.label.text = game.getRating()
        
        let rank = game.getRank()
        if let attString = rank.attributedString {
            rankIconGroup.label.attributedText = attString
        } else {
            rankIconGroup.label.text = rank.text
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
    
    private func configureTitleLabel() {
        let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
        stackView.addArrangedSubview(titleLabel)
        
        titleLabel.text = game.getTitle()
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9

    }
    
    private func configureYearLabel() {
        let yearLabel = UILabel()
        stackView.addArrangedSubview(yearLabel)
        
        yearLabel.text = game.getYearPublished()
        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        yearLabel.textColor = .secondaryLabel
        
    }
    
    private func configureRowStackView() {
        let rowStackView = UIStackView()
        let playersIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.players)
        let timeIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.time)
        let difficultyIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.difficulty)
        let ageIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.age)
        
        stackView.addArrangedSubview(rowStackView)
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach { rowStackView.addArrangedSubview($0)
            $0.label.numberOfLines = 2
        }
        
        rowStackView.backgroundColor = .systemBackground
        rowStackView.distribution = .fillEqually
        
        playersIconGroup.label.text = "\(game.getNumPlayers())\nPlayers"
        timeIconGroup.label.text = "\(game.getPlayTime())\nMinutes"
        difficultyIconGroup.label.text = "\(game.getDifficulty())\nDifficulty"
        ageIconGroup.label.text = "\(game.getMinAge())\nYears"
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = game.getDescription()
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 6
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.isUserInteractionEnabled = true
        
        stackView.addArrangedSubview(descriptionLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    private func configureGalleryImagesTitleLabel() {
        let galleryImagesTitleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
        galleryImagesTitleLabel.text = "Images"
        
        stackView.addArrangedSubview(galleryImagesTitleLabel)
    }
    
    private func configureGalleryImagesContainerView() {
        let galleryImagesContainerView = UIView()
        
        stackView.addArrangedSubview(galleryImagesContainerView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        galleryImagesCollectionView = UICollectionView(frame: galleryImagesContainerView.frame, collectionViewLayout: flowLayout)
        galleryImagesCollectionView.delegate = self
        galleryImagesCollectionView.dataSource = self
        galleryImagesCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        galleryImagesCollectionView.backgroundColor = .systemBackground
        galleryImagesContainerView.addSubview(galleryImagesCollectionView)
        
        galleryImagesContainerView.snp.makeConstraints { make in
            make.height.equalTo(160)
        }
        
        galleryImagesCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureCategoriesSection() {
        let categoriesContainerView = UIView()
        stackView.addArrangedSubview(categoriesContainerView)
        
        let categoriesViewController = TagViewController(title: "Categories", tags: game.categories)
        addChild(categoriesViewController)
        categoriesContainerView.addSubview(categoriesViewController.view)
        categoriesViewController.didMove(toParent: self )
        
        categoriesViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureMechanicsSection() {
        let mechanicsContainerView = UIView()
        stackView.addArrangedSubview(mechanicsContainerView)
        
        let mechanicsViewController = TagViewController(title: "Mechanics", tags: game.mechanics)
        addChild(mechanicsViewController)
        mechanicsContainerView.addSubview(mechanicsViewController.view)
        mechanicsViewController.didMove(toParent: self )
        
        mechanicsViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
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
}

extension GameInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
        cell.set(imageURL: galleryImageURLs[indexPath.row])
        return cell
    }
}

extension GameInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numVisibleImages = 1.5
        let width = collectionView.frame.size.width / CGFloat(numVisibleImages)
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}
