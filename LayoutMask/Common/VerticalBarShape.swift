//
//  VerticalBarShape.swift
//  LayoutMask
//
//  Created by Ice Chen 陳炳璋 on 2022/8/16.
//

import Foundation
import UIKit

protocol MaskProgressable: UIView {
    var progress: CGFloat {get set}
    var lineWidth: CGFloat {get set}
}

enum AnimateStep {
    case setup
    case preStart
    case wait
    case start
    case end
}

class VerticalBarView: UIView, MaskProgressable {
    var lineWidth: CGFloat = 14
    
    // MARK:  Public
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
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.path = path2().cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        (layer as! CAShapeLayer).path = path().cgPath
        (layer.sublayers?[0] as! CAShapeLayer).path = path2().cgPath
    }
    
    var progressTarget: CGFloat = 0.2
    var duration: Double = 10
    var tikProgress: CGFloat = 0
    var endAnimate: (() -> Void) = {}
    var animateStatus: AnimateStep = .setup
}

extension VerticalBarView {
    private func path() -> UIBezierPath {
        let path = UIBezierPath()
        
        let xPoint = center.x
        
        path.move(to: CGPoint(x: xPoint, y: bounds.maxY - 6 - 4 - lineWidth / 2 - 2))
        path.addLine(to: CGPoint(x: xPoint, y: 6 + lineWidth / 2))
        
        return path
    }
    
    private func path2() -> UIBezierPath {
        let xPoint = center.x
        let yPoint = bounds.maxY - 6
        let todayPath = UIBezierPath(arcCenter: CGPoint(x: xPoint, y: yPoint), radius: 2, startAngle: 0, endAngle: 2 * .pi , clockwise: false)
        return todayPath
    }
}

protocol AnimateTik: AnyObject {
    var progressTarget: CGFloat {get set}
    var duration: Double {get set}
    var tikProgress : CGFloat {get set}
    var animateStatus: AnimateStep {get set}
    
    var endAnimate: (()->Void) { get set }
}

extension VerticalBarView: AnimateTik {
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
