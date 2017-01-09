//
//  Draggable.swift
//  DraggableView
//
//  Created by Robert-Hein Hooijmans on 07/01/17.
//  Copyright © 2017 Robert-Hein Hooijmans. All rights reserved.
//

import UIKit

protocol Draggable {
    var pan: UIPanGestureRecognizer? { get }
    var press: UILongPressGestureRecognizer? { get}
    var start: CGPoint { get }
    var target: CGPoint { get }
    var translation: UIViewPropertyAnimator? { get }
    var selection: UIViewPropertyAnimator? { get }
    
    func velocity() -> CGVector
    func spring(for velocity: CGVector) -> UISpringTimingParameters
    func newTranslation(_ translate: @escaping () -> Void) -> UIViewPropertyAnimator
}

extension Draggable where Self: UIView {
    
    func velocity() -> CGVector {
        guard let pan = pan else { return .zero }
        var panVelocity = pan.velocity(in: pan.view)
        
        if pan.translation(in: pan.view).x > 0, center.x > target.x {
            panVelocity.x *= -1
        }
        
        if pan.translation(in: pan.view).y > 0, center.y > target.y {
            panVelocity.y *= -1
        }
        
        return CGVector(with: panVelocity, fraction: 200)
    }
    
    func newTranslation(_ translate: @escaping () -> Void) -> UIViewPropertyAnimator {
        let translation = UIViewPropertyAnimator(duration: 0, timingParameters: spring(for: velocity()))
        translation.addAnimations(translate)
        return translation
    }
    
    func spring(for velocity: CGVector = .zero) -> UISpringTimingParameters {
        return UISpringTimingParameters(mass: 2.5, stiffness: 80, damping: 15, initialVelocity: velocity)
    }
}

extension CGVector {
    
    init(with point: CGPoint, fraction: CGFloat = 1) {
        dx = point.x / fraction
        dy = point.y / fraction
    }
}
