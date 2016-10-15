//
//  BreakoutBehavior.swift
//  Bumping
//
//  Created by Xingan Wang on 10/4/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    fileprivate let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    func addColliderDelegate(_ delegate: UICollisionBehaviorDelegate) {
        collider.collisionDelegate = delegate
    }
    
    fileprivate let ballBehavior: UIDynamicItemBehavior = {
        let dib = UIDynamicItemBehavior()
        dib.elasticity = 1.0
        dib.resistance = 0.0
        dib.friction = 0.0
        return dib
    }()
    
    fileprivate var pushBehavior = UIPushBehavior(items: [], mode: .instantaneous)
    
    func pushBall(_ ball: UIDynamicItem) {
        let angle = CGFloat.random(lower: 0.0, upper: CGFloat(M_PI*2))
        let magnitude = CGFloat(0.3)
        pushBehavior.setAngle(angle, magnitude: magnitude)
        pushBehavior.addItem(ball)
        pushBehavior.active = true
    }
    
    func addItem(_ item: UIDynamicItem) {
        collider.addItem(item)
        ballBehavior.addItem(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collider.removeItem(item)
        ballBehavior.removeItem(item)
    }
    
    func addBarrier(_ path: UIBezierPath, named name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
        addChildBehavior(pushBehavior)
    }
    
    convenience init(collisionDelegate: UICollisionBehaviorDelegate) {
        self.init()
        collider.collisionDelegate = collisionDelegate
    }
}
