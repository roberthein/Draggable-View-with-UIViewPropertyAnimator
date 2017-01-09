//
//  DraggableView.swift
//  DraggableView
//
//  Created by Robert-Hein Hooijmans on 07/01/17.
//  Copyright © 2017 Robert-Hein Hooijmans. All rights reserved.
//

import UIKit

class DraggableView: UIView, Draggable {
    
    var pan: UIPanGestureRecognizer?
    var press: UILongPressGestureRecognizer?
    var start: CGPoint = .zero
    var target: CGPoint = .zero
    var translation: UIViewPropertyAnimator?
    var selection: UIViewPropertyAnimator?
    
    convenience init(with size: CGSize, target: CGPoint) {
        self.init()
        self.target = target
        
        frame.size = size
        center = target
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        pan?.maximumNumberOfTouches = 1
        pan?.delegate = self
        
        press = UILongPressGestureRecognizer(target: self, action: #selector(press(_:)))
        press?.minimumPressDuration = 0
        press?.delegate = self
        
        if let pan = pan, let press = press {
            gestureRecognizers = [pan, press]
        }
    }
    
    func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let current = gestureRecognizer.location(in: gestureRecognizer.view)
        
        switch gestureRecognizer.state {
        case .began:
            start = current
        case .changed:
            let diff = CGPoint(x: current.x - start.x, y: current.y - start.y)
            center = CGPoint(x: center.x + diff.x, y: center.y + diff.y)
        default:
            break
        }
    }
    
    func press(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            layer.zPosition = CGFloat(NSDate().timeIntervalSince1970)
            translation?.stopAnimation(true)
            selected = true
        case .ended, .cancelled, .failed:
            translation = newTranslation {
                self.center = self.target
            }
            translation?.startAnimation()
            selected = false
        default:
            break
        }
    }
    
    var selected: Bool = false {
        didSet {
            selection?.stopAnimation(true)
            selection = UIViewPropertyAnimator(duration: selected ? 0.5 : 1, dampingRatio: selected ? 0.5 : 1, animations: {
                self.transform = self.selected ? CGAffineTransform(scaleX: 1.1, y: 1.1) : .identity
            })
            selection?.startAnimation()
        }
    }
}

extension DraggableView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
