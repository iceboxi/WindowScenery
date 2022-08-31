//
//  VerticalBarShape.swift
//  LayoutMask
//
//  Created by Ice Chen 陳炳璋 on 2022/8/16.
//

import Foundation
import UIKit

class VerticalBarShape: UIView, MaskProgressable {
    var isSelected: Bool = true {
        didSet {
            if isSelected == false, let count = layer.sublayers?.count, count > 0, let selectLayer = layer.sublayers?[0] as? CAShapeLayer {
                selectLayer.removeFromSuperlayer()
            }
        }
    }
    
    // MARK:  Life Cycle
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layer = (self.layer as! CAShapeLayer)
        layer.fillColor = nil
        layer.strokeColor = UIColor.white.cgColor
//        layer.lineWidth = lineWidth
//        layer.path = path(bounds, lineWidth: lineWidth).cgPath
        layer.strokeEnd = 0
        layer.lineCap = .round
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.path = selectedPath().cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        (layer as! CAShapeLayer).path = path(bounds, lineWidth: lineWidth).cgPath
        if let count = layer.sublayers?.count, count > 0, let selectLayer = layer.sublayers?[0] as? CAShapeLayer {
            selectLayer.path = selectedPath().cgPath
        }
    }
    
    // MARK: MaskProgressable
    var lineWidth: CGFloat = 14 {
        didSet {
            (layer as! CAShapeLayer).lineWidth = lineWidth
        }
    }
    var progress: CGFloat = 0 {
        didSet {
            if progress < 0 {
                progress = 0
            } else if progress > 1 {
                progress = 1
            } else {}
            
            (layer as! CAShapeLayer).strokeEnd = progress
        }
    }
    
    // MARK: AnimateTik
    var progressTarget: CGFloat = 0.2
    var duration: Double = 10
    var tikProgress: CGFloat = 0
    var endAnimate: (() -> Void) = {}
    var animateStatus: AnimateStep = .setup
}

extension VerticalBarShape {
    private func selectedPath() -> UIBezierPath {
        let xPoint = center.x
        let yPoint = bounds.maxY - 6
        let todayPath = UIBezierPath(arcCenter: CGPoint(x: xPoint, y: yPoint), radius: 2, startAngle: 0, endAngle: 2 * .pi , clockwise: false)
        return todayPath
    }
    
    func path(_ bounds: CGRect, lineWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        let xPoint = bounds.midX
        
        path.move(to: CGPoint(x: xPoint, y: bounds.maxY - 6 - 4 - lineWidth / 2 - 2))
        path.addLine(to: CGPoint(x: xPoint, y: 6 + lineWidth / 2))
        
        return path
    }
}

extension VerticalBarShape: AnimateTik {
    @objc func onTik() {
        switch animateStatus {
        case .setup:
            tikProgress = 0
            progress = tikProgress
            animateStatus = .preStart
        case .preStart:
            let tik = 1.0 / 60 / 1
            tikProgress += tik
            if tikProgress > 1 {
                tikProgress = 1
                animateStatus = .wait
            }
            progress = tikProgress
        case .wait:
            let tik = 1.0 / 60 / 2
            tikProgress += tik
            if tikProgress > (1 + tik * 60 * 2) {
                tikProgress = 1
                animateStatus = .start
            }
        case .start:
            let tik = 1.0 / 60 / 1
            tikProgress -= tik
            if tikProgress < progressTarget {
                tikProgress = progressTarget
                animateStatus = .end
            }
            progress = tikProgress
        case .end:
            endAnimate()
        }
    }
}
