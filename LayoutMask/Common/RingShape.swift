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
        layer.lineWidth = lineWidth
        layer.path = path().cgPath
        layer.strokeEnd = 0
        layer.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        (layer as! CAShapeLayer).path = path().cgPath
    }
    
    // MARK: MaskProgressable
    var lineWidth: CGFloat = 5
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
    var duration: Double = 10
    var tikProgress: CGFloat = 0
    var endAnimate: (() -> Void) = {}
    var animateStatus: AnimateStep = .setup
}

extension RingShape {
    private func path() -> UIBezierPath {
        let radius = floor(min((bounds.width - lineWidth) / 2, (bounds.height - lineWidth) / 2))
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: -CGFloat(Float.pi / 2), endAngle: CGFloat(Float.pi / 2) * 3.0, clockwise: true)
        return path
    }
}

extension RingShape: AnimateTik {
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
        case .wait:
            let tik = 1.0 / 60 / 2
            tikProgress += tik
            if tikProgress > (1 + tik * 60 * 2) {
                tikProgress = 0
                animateStatus = .start
            }
        case .start:
            let tik = 1.0 / 60 / 1
            tikProgress += tik
            if tikProgress > progressTarget {
                tikProgress = progressTarget
                animateStatus = .end
            }
            progress = tikProgress
        case .end:
            endAnimate()
        }
    }
}
