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
    let favoriteButton = FavoriteButton()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let yearLabel = UILabel()
    let rowStackView = UIStackView()
    let descriptionLabel = UILabel()
    
    var galleryImagesViewController: GalleryImagesViewController!
    let galleryImagesContainerView = UIView()
    let categoriesContainerView = UIView()
    
    private let headerImageViewHeight = 300
    private let horizontalPadding: CGFloat = 20
    
    var game: Game!
    var descriptionExpanded = false
    
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
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureHeaderImageView()
        configureLargeIconView()
        configureTitleLabel()
        configureYearLabel()
        configureRowStackView()
        configureDescriptionLabel()
        configureGalleryImagesSection()
        configureCategoriesSection()
        configureMechanicsSection()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureHeaderImageView() {
        scrollView.addSubview(headerImageView)

        headerImageView.layer.cornerRadius = 0
        
        if let imageURL = game.imageURL {
            headerImageView.setImage(from: imageURL)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view)
            make.height.equalTo(headerImageViewHeight)
        }
    }
    
    private func configureLargeIconView() {
        let ratingIconGroup = PrimaryIconGroupView(labelText: "N/A", iconImage: Images.rating)
        let rankIconGroup = PrimaryIconGroupView(labelText: "N/A", iconImage: Images.rank)

        scrollView.addSubview(largeIconView)
        [ratingIconGroup, rankIconGroup, favoriteButton].forEach { largeIconView.addSubview($0) }
        
        ratingIconGroup.label.text = game.getRating()
        
        let rank = game.getRank()
        if let attString = rank.attributedString {
            rankIconGroup.label.attributedText = attString
        } else {
            rankIconGroup.label.text = rank.text
        }
        
        let buttonImage = self.game!.isInFavorites() ? Images.filledHeart : Images.emptyHeart
        favoriteButton.setImage(buttonImage, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
        
        largeIconView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(Layout.mediumPadding)
            make.leading.trailing.equalTo(view).inset(horizontalPadding)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalToSuperview()
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(20)
            make.centerY.equalTo(ratingIconGroup)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(2)
            make.width.equalTo(34)
        }
    }
    
    private func configureTitleLabel() {
        scrollView.addSubview(titleLabel)
    
        titleLabel.text = game.getTitle()
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(largeIconView.snp.bottom).offset(Layout.mediumPadding)
            make.leading.trailing.equalTo(view).inset(horizontalPadding)
        }

    }
    
    private func configureYearLabel() {
        scrollView.addSubview(yearLabel)
        
        yearLabel.text = game.getYearPublished()
        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        yearLabel.textColor = .secondaryLabel
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.smallPadding)
            make.leading.equalTo(view).offset(horizontalPadding + 2)
            make.trailing.equalTo(view).offset(-horizontalPadding)
        }
    }
    
    private func configureRowStackView() {
        let playersIconGroup = GameInfoIconGroupView(labelText: "N/A", iconImage: Images.players)
        let timeIconGroup = GameInfoIconGroupView(labelText: "N/A", iconImage: Images.time)
        let difficultyIconGroup = GameInfoIconGroupView(labelText: "N/A", iconImage: Images.difficulty)
        let ageIconGroup = GameInfoIconGroupView(labelText: "N/A", iconImage: Images.age)
        
        scrollView.addSubview(rowStackView)
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach { rowStackView.addArrangedSubview($0)
            $0.label.numberOfLines = 2
        }
        
        rowStackView.distribution = .fillEqually
        
        playersIconGroup.label.text = "\(game.getNumPlayers())\nPlayers"
        timeIconGroup.label.text = "\(game.getPlayTime())\nMinutes"
        difficultyIconGroup.label.text = "\(game.getDifficulty())\nDifficulty"
        ageIconGroup.label.text = "\(game.getMinAge())\nYears"
        
        rowStackView.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(Layout.largePadding)
            make.leading.trailing.equalTo(view).inset(Layout.smallPadding)
        }
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = game.getDescription()
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 6
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.isUserInteractionEnabled = true
        
        scrollView.addSubview(descriptionLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        descriptionLabel.addGestureRecognizer(tapGesture)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(rowStackView.snp.bottom).offset(Layout.largePadding)
            make.leading.trailing.equalTo(view).inset(horizontalPadding)
        }
    }
    
    private func configureGalleryImagesSection() {
        scrollView.addSubview(galleryImagesContainerView)
        
        galleryImagesViewController = GalleryImagesViewController(title: "Images", id: game.id!)
        addChild(galleryImagesViewController)
        galleryImagesContainerView.addSubview(galleryImagesViewController.view)
        galleryImagesViewController.didMove(toParent: self)
        
        galleryImagesContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Layout.largePadding)
            make.leading.equalTo(view).offset(horizontalPadding)
            make.trailing.equalTo(view).offset(-horizontalPadding)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
        
        galleryImagesViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureCategoriesSection() {
        scrollView.addSubview(categoriesContainerView)
        
        let categoriesViewController = TagViewController(title: "Categories", tags: game.categories, borderColor: Colors.teal)
        addChild(categoriesViewController)
        categoriesContainerView.addSubview(categoriesViewController.view)
        categoriesViewController.didMove(toParent: self )
        
        categoriesContainerView.snp.makeConstraints { make in
            make.top.equalTo(galleryImagesContainerView.snp.bottom).offset(Layout.largePadding)
            make.leading.trailing.equalTo(view).inset(horizontalPadding)
        }
        
        categoriesViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureMechanicsSection() {
        let mechanicsContainerView = UIView()
        scrollView.addSubview(mechanicsContainerView)
        
        let mechanicsViewController = TagViewController(title: "Mechanics", tags: game.mechanics, borderColor: Colors.yellow)
        addChild(mechanicsViewController)
        mechanicsContainerView.addSubview(mechanicsViewController.view)
        mechanicsViewController.didMove(toParent: self )
        
        mechanicsContainerView.snp.makeConstraints { make in
            make.top.equalTo(categoriesContainerView.snp.bottom).offset(Layout.largePadding)
            make.leading.trailing.equalTo(view).inset(horizontalPadding)
            make.bottom.equalToSuperview()
        }
        
        mechanicsViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func favoriteButtonPressed(_ sender: UIButton) {
        let isInFavorites = game.isInFavorites()
        
        if isInFavorites {
            game.setFavorite(to: false)
            favoriteButton.setImage(Images.emptyHeart, for: .normal)
        } else {
            game.setFavorite(to: true)
            favoriteButton.setImage(Images.filledHeart, for: .normal)
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
