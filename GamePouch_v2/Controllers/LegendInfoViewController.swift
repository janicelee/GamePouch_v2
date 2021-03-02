//
//  LegendInfoViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-22.
//

import UIKit
import SafariServices

class LegendInfoViewController: UIViewController {
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let detailedInfoView = DetailedInfoView()
    let attributionButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @objc private func presentSafariViewController() {
        if let url = URL(string: "https://icons8.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Configuration
    
    private func configure() {
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
        configureContainerView()
        configureTitleLabel()
        configureDetailedInfoView()
        configureAttributionButton()
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.systemGray.cgColor
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 6
        containerView.layer.shouldRasterize = true // caches rendered shadow
        containerView.layer.rasterizationScale = UIScreen.main.scale
        
        let width: CGFloat = 260
        let height: CGFloat = 220
        
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        
        titleLabel.text = "Legend"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: FontSize.large, weight: .bold)
        titleLabel.textColor = .label
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Layout.xLargePadding)
        }
    }
    
    private func configureDetailedInfoView() {
        containerView.addSubview(detailedInfoView)
        
        detailedInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.xLargePadding)
            make.leading.trailing.bottom.equalToSuperview().inset(Layout.xLargePadding)
        }
    }
    
    private func configureAttributionButton() {
        containerView.addSubview(attributionButton)

        attributionButton.setTitle("Icon art by Icons8", for: .normal)
        attributionButton.setTitleColor(.secondaryLabel, for: .normal)
        attributionButton.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.small, weight: .regular)
        attributionButton.addTarget(self, action: #selector(presentSafariViewController), for: .touchUpInside)
        
        attributionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Layout.xLargePadding)
            make.bottom.equalToSuperview().inset(Layout.smallPadding)
        }
    }
}
