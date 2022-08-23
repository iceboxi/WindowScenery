//
//  WindowSceneryView.swift
//  LayoutMask
//
//  Created by Ice Chen 陳炳璋 on 2022/8/16.
//

import UIKit

class WindowSceneryView: UIView {
    enum WindowType {
        case ring
        case verticalBar(isSelected: Bool)
        
        func getMask() -> MaskProgressable {
            switch self {
            case .ring:
                return RingShape()
            case .verticalBar(let isSelected):
                let shape = VerticalBarView()
                shape.isSelected = isSelected
                return shape
            }
        }
    }
    
    // 景（图片）
    private lazy var sceneryView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "img_usage_level_gradient")
        
        return view
    }()
    
    var progress: CGFloat = 0 {
        didSet {
            let target = (sceneryView.mask as? AnimateTik & MaskProgressable)
            target?.progress = progress
            target?.progressTarget = progress
        }
    }
    private var displayLink: CADisplayLink?
    
    var type: WindowType = .ring {
        didSet {
            let customMask = type.getMask()
            customMask.frame = bounds
            customMask.center = CGPoint(x: sceneryView.bounds.midX, y: sceneryView.bounds.midY)
            customMask.progress = progress
            sceneryView.mask = customMask
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = .purple
        
        sceneryView.frame = bounds
        self.addSubview(sceneryView)
        
        let customMask = type.getMask()
        customMask.frame = bounds
        customMask.center = CGPoint(x: sceneryView.bounds.midX, y: sceneryView.bounds.midY)
        customMask.progress = progress
        sceneryView.mask = customMask
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.type = .conic
//        gradientLayer.colors = [
//            UIColor(red: 128.0/255.0, green: 249.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor,
//            UIColor(red: 114.0/255.0, green: 234.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor,
//            UIColor(red: 96.0/255.0, green: 215.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor,
//            UIColor(red: 74.0/255.0, green: 192.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor,
//            UIColor(red: 59.0/255.0, green: 178.0/255.0, blue: 232.0/255.0, alpha: 1.0).cgColor,
//            UIColor(red: 20.0/255.0, green: 137.0/255.0, blue: 247.0/255.0, alpha: 1.0).cgColor,
//            UIColor(red: 0.0/255.0, green: 116.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor,
//        ]
//        gradientLayer.frame = frontView.bounds
//        frontView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WindowSceneryView {
    func startAnimation() {
        guard let target = sceneryView.mask as? AnimateTik else {
            return
        }
        
        displayLink?.invalidate()
        
        target.endAnimate = { [weak self] in
            self?.stopAnimation()
        }
        target.animateStatus = .setup
        let displayLink = CADisplayLink(target: target, selector: #selector(onTik))
        displayLink.add(to: RunLoop.main, forMode: .common)
        self.displayLink = displayLink
    }
    
    @objc private func onTik() {
    }
    
    private func stopAnimation() {
        displayLink?.invalidate()
    }
}
