//
//  EmptyStateView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-24.
//

import UIKit

class EmptyFavoritesView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = TitleLabel(textAlignment: .center, fontSize: FontSize.xLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        titleLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.image = Images.filledHeart
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layout.largePadding)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Layout.xLargePadding)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

//class GFEmptyStateView: UIImageView {
//
//    private func configureMessageLabel() {
//        addSubview(messageLabel)
//        messageLabel.numberOfLines = 3
//        messageLabel.textColor = .secondaryLabel
//
//        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
//
//        NSLayoutConstraint.activate([
//            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant),
//            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
//            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
//            messageLabel.heightAnchor.constraint(equalToConstant: 200)
//        ])
//    }
//
//    private func configureLogoImageView() {
//        addSubview(logoImageView)
//        logoImageView.image = Images.emptyStateLogo
//        logoImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
//
//        NSLayoutConstraint.activate([
//            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 1.3),
//            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, constant: 1.3),
//            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
//            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomConstant)
//        ])
//    }
//}
//
