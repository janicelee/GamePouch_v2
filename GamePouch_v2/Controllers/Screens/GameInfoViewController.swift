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
    let mainAttributesView = UIView()
    let favoriteButton = FavoriteButton()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: FontSize.xLarge)
    let yearLabel = UILabel()
    let secondaryAttributesStackView: GameAttributesStackView!
    let descriptionLabel = UILabel()
    
    var galleryImagesViewController: GalleryImagesViewController!
    let galleryImagesContainerView = UIView()
    let categoriesContainerView = UIView()
    
    private let headerImageViewHeight = 300
    private let favoriteButtonWidth: CGFloat = 34
    
    var game: Game!
    var descriptionExpanded = false
    
    init(game: Game) {
        self.game = game
        self.secondaryAttributesStackView = GameAttributesStackView(game: game)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFavorite()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureHeaderImageView()
        configureMainAttributesView()
        configureTitleLabel()
        configureYearLabel()
        configureSecondaryAttributesStackView()
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
    
    private func configureMainAttributesView() {
        let ratingIconGroup = MainAttributesIconGroup(label: "N/A", icon: Images.rating)
        let rankIconGroup = MainAttributesIconGroup(label: "N/A", icon: Images.rank)

        scrollView.addSubview(mainAttributesView)
        [ratingIconGroup, rankIconGroup, favoriteButton].forEach { mainAttributesView.addSubview($0) }
        
        ratingIconGroup.label.text = game.getRating()
        
        if let rank = game.getRank(),
           let attString = rank.toOrdinalString(fontSize: FontSize.medium, superscriptFontSize: FontSize.superscript, weight: .bold) {
            rankIconGroup.label.attributedText = attString
        } else {
            rankIconGroup.label.text = "N/A"
        }
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
        
        mainAttributesView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(Layout.largePadding)
            make.leading.trailing.equalTo(view).inset(Layout.xxLargePadding)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.smallPadding)
            make.leading.equalToSuperview()
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(Layout.xxLargePadding)
            make.centerY.equalTo(ratingIconGroup)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(Layout.xsPadding)
            make.width.equalTo(favoriteButtonWidth)
        }
    }
    
    private func configureTitleLabel() {
        scrollView.addSubview(titleLabel)
    
        titleLabel.text = game.getTitle()
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainAttributesView.snp.bottom).offset(Layout.largePadding)
            make.leading.trailing.equalTo(view).inset(Layout.xxLargePadding)
        }

    }
    
    private func configureYearLabel() {
        scrollView.addSubview(yearLabel)
        
        yearLabel.text = game.getYearPublished()
        yearLabel.font = UIFont.systemFont(ofSize: FontSize.small, weight: .bold)
        yearLabel.textColor = .secondaryLabel
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.mediumPadding)
            make.leading.equalTo(view).offset(Layout.xxLargePadding + 2)
            make.trailing.equalTo(view).offset(-Layout.xxLargePadding)
        }
    }
    
    private func configureSecondaryAttributesStackView() {
        scrollView.addSubview(secondaryAttributesStackView)

        secondaryAttributesStackView.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(Layout.xLargePadding)
            make.leading.trailing.equalTo(view).inset(Layout.mediumPadding)
        }
    }
    
    private func configureDescriptionLabel() {
        scrollView.addSubview(descriptionLabel)
        
        descriptionLabel.text = game.getDescription()
        descriptionLabel.font = UIFont.systemFont(ofSize: FontSize.small)
        descriptionLabel.numberOfLines = 6
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        descriptionLabel.addGestureRecognizer(tapGesture)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(secondaryAttributesStackView.snp.bottom).offset(Layout.xLargePadding)
            make.leading.trailing.equalTo(view).inset(Layout.xxLargePadding)
        }
    }
    
    private func configureGalleryImagesSection() {
        scrollView.addSubview(galleryImagesContainerView)
        
        galleryImagesViewController = GalleryImagesViewController(title: "Images", id: game.id!)
        addChild(galleryImagesViewController)
        galleryImagesContainerView.addSubview(galleryImagesViewController.view)
        galleryImagesViewController.didMove(toParent: self)
        
        galleryImagesContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Layout.xLargePadding)
            make.leading.equalTo(view).offset(Layout.xxLargePadding)
            make.trailing.equalTo(view).offset(-Layout.xxLargePadding)
            make.height.equalTo(view.snp.height).multipliedBy(0.26)
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
            make.top.equalTo(galleryImagesContainerView.snp.bottom).offset(Layout.xLargePadding)
            make.leading.trailing.equalTo(view).inset(Layout.xxLargePadding)
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
            make.top.equalTo(categoriesContainerView.snp.bottom).offset(Layout.xLargePadding)
            make.leading.trailing.equalTo(view).inset(Layout.xxLargePadding)
            make.bottom.equalToSuperview()
        }
        
        mechanicsViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func favoriteButtonPressed(_ sender: UIButton) {
        do {
            let isInFavorites = try game.isInFavorites()
            try game.setFavorite(to: !isInFavorites)
            favoriteButton.set(active: !isInFavorites)
        } catch let error as InternalError {
            presentErrorAlertOnMainThread(message: UserError.generic.rawValue)
            print("\(error.rawValue), id: \(game?.id ?? "")")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    private func setFavorite() {
        do {
            let isFavorite = try self.game.isInFavorites(skipCache: true)
            self.favoriteButton.set(active: isFavorite)
        } catch let error as InternalError {
            print("\(error.rawValue), id: \(game?.id ?? "")")
        } catch {
            print("Unexpected error: \(error)")
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
