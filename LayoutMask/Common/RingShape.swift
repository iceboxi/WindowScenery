//
//  RingShape.swift
//  LayoutMask
//
//  Created by Ice Chen 陳炳璋 on 2022/8/16.
//

import Foundation
import UIKit

class RingShape: UIView, MaskProgressable {
    // MARK:  Life Cycle
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let layer = (self.layer as! CAShapeLayer)
        layer.fillColor = nil
        layer.strokeColor = UIColor.white.cgColor
        layer.strokeEnd = 0
        layer.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        (layer as! CAShapeLayer).path = path(bounds, lineWidth: lineWidth).cgPath
    }
    
    // MARK: MaskProgressable
    var lineWidth: CGFloat = 5 {
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
    var progressTarget: CGFloat = 0.5
}

extension RingShape {
    func path(_ bounds: CGRect, lineWidth: CGFloat) -> UIBezierPath {
        let radius = floor(min((bounds.width - lineWidth) / 2, (bounds.height - lineWidth) / 2))
        
        let start = 83.0
        let startAngle = -(start * .pi / 180)
        let endAngle = 2 * .pi + startAngle
        
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return path
    }
}

extension RingShape: AnimateTik {
    func animate(_ animate: Bool) {
        guard animate else {
            return progress = progressTarget
        }
        
        let animation = CAKeyframeAnimation(keyPath: "strokeEnd")
        animation.values = [0, 0, progressTarget]
        animation.keyTimes = [0, 0.62, 1]
        animation.duration = 2.1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        (layer as! CAShapeLayer).add(animation, forKey: "line")
    }
}
