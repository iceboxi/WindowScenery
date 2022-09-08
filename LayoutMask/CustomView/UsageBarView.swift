//
//  UsageBarView.swift
//  MobileApp
//
//  Created by Ice Chen 陳炳璋 on 2022/9/1.
//  Copyright © 2022 Gogoro Taiwan Limited. All rights reserved.
//

import UIKit

class UsageBarView: UIView {
    var progress: [CGFloat] = [] {
        didSet {
            setupProgress(progress.map({ Double($0) }))
        }
    }
    
    private let stackView: UIStackView = UIStackView(frame: .zero)
    private let bgColors: [UIColor] = [
        UIColor(red: 128.0/255.0, green: 249.0/255.0, blue: 206.0/255.0, alpha: 1.0),
        UIColor(red: 114.0/255.0, green: 234.0/255.0, blue: 212.0/255.0, alpha: 1.0),
        UIColor(red: 96.0/255.0, green: 215.0/255.0, blue: 219.0/255.0, alpha: 1.0),
        UIColor(red: 74.0/255.0, green: 192.0/255.0, blue: 227.0/255.0, alpha: 1.0),
        UIColor(red: 59.0/255.0, green: 178.0/255.0, blue: 232.0/255.0, alpha: 1.0),
        UIColor(red: 20.0/255.0, green: 137.0/255.0, blue: 247.0/255.0, alpha: 1.0),
        UIColor(red: 0.0/255.0, green: 116.0/255.0, blue: 255.0/255.0, alpha: 1.0),
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for i in 0...6 {
            let window = WindowSceneryView(frame: .zero)
            window.tag = i
            window.lineWidth = 14
            window.type = .verticalBar(isSelected: i == 6 ? true : false)
            window.progress = 1
            window.sceneryView.image = nil
            window.sceneryView.backgroundColor = bgColors[i]
            stackView.addArrangedSubview(window)
        }
    }
    
    func setupProgress(_ value: [Double], animate: Bool = false) {
        let min = min(value.count, stackView.arrangedSubviews.count)
        
        for i in 0..<min {
            if let window = stackView.arrangedSubviews[i] as? WindowSceneryView {
                window.progress = value[i]
                window.startChange(value[i] == 0 ? false : animate)
            }
        }
    }
}
