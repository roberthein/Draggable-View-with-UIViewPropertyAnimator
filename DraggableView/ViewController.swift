//
//  ViewController.swift
//  DraggableView
//
//  Created by Robert-Hein Hooijmans on 07/01/17.
//  Copyright © 2017 Robert-Hein Hooijmans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        let margin: CGFloat = 20
        let size = CGSize(width: 150, height: 150)
        let colors = [
            UIColor(red: 1, green: 0.65, blue: 0.1, alpha: 1),
            UIColor(red: 0.5, green: 0, blue: 1, alpha: 1),
            UIColor(red: 0.35, green: 0.8, blue: 0.32, alpha: 1)
        ]
        
        for (i, color) in colors.enumerated() {
            let object = DraggableView(with: size, target: CGPoint(x: view.center.x, y: view.center.y + (CGFloat(i - 1) * (size.height + margin))))
            object.backgroundColor = color
            object.layer.cornerRadius = 5
            view.addSubview(object)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
