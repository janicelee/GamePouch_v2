//
//  LegendInfoViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-22.
//

import UIKit
import SafariServices

class LegendInfoViewController: UIViewController {
    
    private let containerView = UIView()
    private let legendInfoView = LegendInfoView()
    private let iconsAttributionButton = UIButton()
    private let iconsAttributionURL = "https://icons8.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @objc private func presentSafariViewController() {
        if let url = URL(string: iconsAttributionURL) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }
    
    // Dismiss view controller if user taps outside containerView frame
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    @objc private func dismissToPreviousScreen() -> Bool {
        dismiss(animated: true)
        return true
    }
    
    // MARK: - Configuration
    
    private func configure() {
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.4)
        
        let dismissLegend = UIAccessibilityCustomAction(name: "Dismiss legend", target: self, selector: #selector(dismissToPreviousScreen))
        view.accessibilityCustomActions = [dismissLegend]
        
        configureContainerView()
        configureLegendInfoView()
        configureIconsLinkButton()
        configureDataAttributionLabel()
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
        let height: CGFloat = 228
        
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
    
    private func configureLegendInfoView() {
        containerView.addSubview(legendInfoView)

        legendInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.largePadding)
            make.leading.trailing.equalToSuperview().inset(Layout.xLargePadding)
        }
    }
    
    private func configureIconsLinkButton() {
        containerView.addSubview(iconsAttributionButton)

        iconsAttributionButton.setTitle("Icon art by Icons8", for: .normal)
        iconsAttributionButton.setTitleColor(.secondaryLabel, for: .normal)
        iconsAttributionButton.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.xs, weight: .light)
        iconsAttributionButton.addTarget(self, action: #selector(presentSafariViewController), for: .touchUpInside)
        
        iconsAttributionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Layout.xLargePadding)
        }
    }
    
    private func configureDataAttributionLabel() {
        let label = UILabel()
        containerView.addSubview(label)
        
        label.text = "Powered by BoardGameGeek"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.xs, weight: .light)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconsAttributionButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Layout.xLargePadding)
            make.bottom.equalToSuperview().inset(Layout.largePadding)
        }
    }
}
