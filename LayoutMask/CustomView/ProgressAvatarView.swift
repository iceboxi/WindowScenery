//
//  ProgressAvatarView.swift
//  MobileApp
//
//  Created by Ice Chen 陳炳璋 on 2022/9/1.
//  Copyright © 2022 Gogoro Taiwan Limited. All rights reserved.
//

import UIKit

class ProgressAvatarView: UIView {
    var avatarImageView: UIImageView = UIImageView(image: UIImage(named: "icon_btn_m_myaccount"))
    var progress: CGFloat = 0 {
        didSet {
            setupProgress(progress)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let imageInset: CGFloat = 6
    func setup() {
        let window = WindowSceneryView(frame: bounds)
        window.tag = 1
        window.lineWidth = 4
        window.type = .ring
        window.progress = 0
        addSubview(window)
        
        window.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            window.leadingAnchor.constraint(equalTo: leadingAnchor),
            window.trailingAnchor.constraint(equalTo: trailingAnchor),
            window.topAnchor.constraint(equalTo: topAnchor),
            window.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let inset = imageInset * 2
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.frame = CGRect(x: 0, y: 0, width: frame.width - inset, height: frame.height - inset)
        avatarImageView.center = center
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
        addSubview(avatarImageView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: imageInset),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imageInset),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: imageInset),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -imageInset)
        ])
    }
    
    func setupProgress(_ value: CGFloat, animate: Bool = false) {
        if let window = viewWithTag(1) as? WindowSceneryView {
            window.progress = value
            window.startChange(animate)
        }
    }
}
