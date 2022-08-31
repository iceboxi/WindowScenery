//
//  ViewController.swift
//  LayoutMask
//
//  Created by Ice Chen 陳炳璋 on 2022/8/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let width = 50.0
        for i in 0...5 {
            let window = WindowSceneryView(frame: CGRect(x: 20 + width * Double(i), y: 70, width: width, height: 200))
            window.tag = i + 1
//            window.lineWidth = 14
            window.type = .verticalBar(isSelected: true)
//            window.sceneryView.image = UIImage(named: "color")
//            window.type = .ring
            window.progress = 0.5
            view.addSubview(window)
        }
        
        view.backgroundColor = .yellow
    }
    
    @IBAction func animate(_ sender: Any) {
        for i in 0...5 {
            if let window = view.viewWithTag(i + 1) as? WindowSceneryView {
                window.startAnimation()
            }
        }
    }
}

