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
                let shape = RingShape()
                return shape
            case .verticalBar(let isSelected):
                let shape = VerticalBarShape()
                shape.isSelected = isSelected
                return shape
            }
        }
    }
    
    var sceneryView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "img_usage_level_gradient")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var progress: CGFloat = 0 {
        didSet {
            let target = (sceneryView.mask as? AnimateTik & MaskProgressable)
            target?.progressTarget = progress
        }
    }
    private var displayLink: CADisplayLink?
    
    var showNotch = true
    var lineWidth: CGFloat = 14.0
    var type: WindowType = .ring {
        didSet {
            let customMask = type.getMask()
            customMask.lineWidth = lineWidth
            customMask.frame = bounds
            customMask.center = CGPoint(x: sceneryView.bounds.midX, y: sceneryView.bounds.midY)
            customMask.progress = progress
            sceneryView.mask = customMask
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
    
    func setup() {
        let backLayer = CAShapeLayer()
        backLayer.fillColor = nil
        backLayer.strokeColor = UIColor.gray.cgColor
        backLayer.strokeEnd = 1
        backLayer.lineCap = .round
        self.layer.addSublayer(backLayer)
        
        sceneryView.frame = bounds
        self.addSubview(sceneryView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sceneryView.frame = bounds
        sceneryView.mask?.frame = bounds
        if showNotch, let count = layer.sublayers?.count, count > 0, let backLayer = layer.sublayers?[0] as? CAShapeLayer {
            backLayer.lineWidth = lineWidth
            backLayer.path = type.getMask().path(bounds, lineWidth: lineWidth).cgPath
        }
    }
}

extension WindowSceneryView {
    func startChange(_ animate: Bool = true) {
        guard let target = sceneryView.mask as? AnimateTik else {
            return
        }
        
        displayLink?.invalidate()
        
        target.endAnimate = { [weak self] in
            self?.stopAnimation()
        }
        
        target.animateStatus = animate ? .setup : .end
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
