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
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let yearLabel = UILabel()
    let rowStackView = UIStackView()
    let descriptionLabel = UILabel()
    
    var galleryImagesViewController: GalleryImagesViewController!
    let galleryImagesContainerView = UIView()
    let categoriesContainerView = UIView()
    
    let edgePadding: CGFloat = 20
    let verticalPadding: CGFloat = 8
    let rowStackViewPadding: CGFloat = 8
    
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
        downloadGalleryImages()
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
            make.height.equalTo(300)
        }
    }
    
    private func configureLargeIconView() {
        let ratingIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rating)
        let rankIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rank)

        scrollView.addSubview(largeIconView)
        [ratingIconGroup, rankIconGroup].forEach { largeIconView.addSubview($0) }
        
        ratingIconGroup.label.text = game.getRating()
        
        let rank = game.getRank()
        if let attString = rank.attributedString {
            rankIconGroup.label.attributedText = attString
        } else {
            rankIconGroup.label.text = rank.text
        }
        
        largeIconView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
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
        scrollView.addSubview(titleLabel)
    
        titleLabel.text = game.getTitle()
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(largeIconView.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
        }

    }
    
    private func configureYearLabel() {
        scrollView.addSubview(yearLabel)
        
        yearLabel.text = game.getYearPublished()
        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        yearLabel.textColor = .secondaryLabel
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(edgePadding + 2)
            make.trailing.equalTo(view).offset(-edgePadding)
        }
    }
    
    private func configureRowStackView() {
        let playersIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.players)
        let timeIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.time)
        let difficultyIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.difficulty)
        let ageIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.age)
        
        scrollView.addSubview(rowStackView)
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach { rowStackView.addArrangedSubview($0)
            $0.label.numberOfLines = 2
        }
        
        rowStackView.backgroundColor = .systemBackground
        rowStackView.distribution = .fillEqually
        
        playersIconGroup.label.text = "\(game.getNumPlayers())\nPlayers"
        timeIconGroup.label.text = "\(game.getPlayTime())\nMinutes"
        difficultyIconGroup.label.text = "\(game.getDifficulty())\nDifficulty"
        ageIconGroup.label.text = "\(game.getMinAge())\nYears"
        
        rowStackView.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(rowStackViewPadding)
            make.trailing.equalTo(view).offset(-rowStackViewPadding)
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
            make.top.equalTo(rowStackView.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
        }
    }
    
    private func configureGalleryImagesSection() {
        scrollView.addSubview(galleryImagesContainerView)
        
        galleryImagesViewController = GalleryImagesViewController(title: "Images", imageURLs: [])
        addChild(galleryImagesViewController)
        galleryImagesContainerView.addSubview(galleryImagesViewController.view)
        galleryImagesViewController.didMove(toParent: self)
        
        galleryImagesContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
        
        galleryImagesViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureCategoriesSection() {
        scrollView.addSubview(categoriesContainerView)
        
        let categoriesViewController = TagViewController(title: "Categories", tags: game.categories)
        addChild(categoriesViewController)
        categoriesContainerView.addSubview(categoriesViewController.view)
        categoriesViewController.didMove(toParent: self )
        
        categoriesContainerView.snp.makeConstraints { make in
            make.top.equalTo(galleryImagesContainerView.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
        }
        
        categoriesViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureMechanicsSection() {
        let mechanicsContainerView = UIView()
        scrollView.addSubview(mechanicsContainerView)
        
        let mechanicsViewController = TagViewController(title: "Mechanics", tags: game.mechanics)
        addChild(mechanicsViewController)
        mechanicsContainerView.addSubview(mechanicsViewController.view)
        mechanicsViewController.didMove(toParent: self )
        
        mechanicsContainerView.snp.makeConstraints { make in
            make.top.equalTo(categoriesContainerView.snp.bottom).offset(verticalPadding * 2)
            make.leading.equalTo(view).offset(edgePadding)
            make.trailing.equalTo(view).offset(-edgePadding)
            make.bottom.equalToSuperview()
        }
        
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
                self.galleryImagesViewController.imageURLs = urls
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
