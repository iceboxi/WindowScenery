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
        
        
        let window = WindowSceneryView(frame: CGRect(x: 20, y: 70, width: 200, height: 200))
        window.tag = 1
        window.type = .verticalBar(isSelected: true)
        window.progress = 0.6
        view.addSubview(window)
        
        view.backgroundColor = .yellow
    }
    
    @IBAction func animate(_ sender: Any) {
        if let window = view.viewWithTag(1) as? WindowSceneryView {
            window.startAnimation()
        }
    }
}

