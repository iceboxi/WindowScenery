//
//  ProgressAnimae.swift
//  LayoutMask
//
//  Created by Ice Chen 陳炳璋 on 2022/8/23.
//

import Foundation
import UIKit

protocol MaskProgressable: UIView {
    var progress: CGFloat {get set}
    var lineWidth: CGFloat {get set}
    
    func path(_ bounds: CGRect, lineWidth: CGFloat) -> UIBezierPath
}

protocol AnimateTik: AnyObject {
    var progressTarget: CGFloat {get set}
    
    func animate(_ animate: Bool)
}
