//
//  BumpingView.swift
//  Bumping
//
//  Created by Xingan Wang on 10/1/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class BumpingView: NamedBezierPathsView, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {

    // MARK - Configuations and sizes
    fileprivate let numberOfRows        = 5
    fileprivate let bricksPerRow        = 5
    fileprivate let intervalWidthRatio  = 5
    fileprivate let intervalHeightRatio = 2
    fileprivate let paddleHeight        = 60
    fileprivate let brickColor          = UIColor.blue
    fileprivate let paddleColor            = UIColor.green
    fileprivate let ballColor           = UIColor.red
    
    var numberOfBricks: Int = 0 {
        didSet {
            if (oldValue == 1 && numberOfBricks == 0) {
                resetBricks()
                resetBall()
                animator.updateItem(usingCurrentState: self.ball)
            }
        }
    }
    
    fileprivate var brickSize: CGSize {
        let w = bounds.size.width / CGFloat(Double(bricksPerRow) + Double(bricksPerRow+1) / Double(intervalWidthRatio))
        let h = (w / 5) < 10 ? 10 : (w / 5)
        return CGSize(width: w, height: h)
    }
    
    fileprivate var paddleSize: CGSize {
        let bs = brickSize
        return CGSize(width: bs.width * 1.5, height: bs.height / 2)
    }
    
    fileprivate var ballRadius: CGFloat {
        var r = brickSize.width / 4
        if (r > 20) {
            r = 20
        } else if (r < 10) {
            r = 10
        }
        return CGFloat(r)
    }
    
    // MARK - Drawed outlets
    var ball: UIView! {
        didSet {
            ball.backgroundColor = ballColor
            ball.layer.cornerRadius = ball.frame.size.height / 2
            ball.clipsToBounds = true
        }
    }
    var paddle: UIBezierPath! {
        didSet {
            bezierPaths[PathNames.paddleBarrier] = paddle
            fillColors[PathNames.paddleBarrier] = UIColor.gray
            bumpingBehavior.addBarrier(paddle, named: PathNames.paddleBarrier)
        }
    }
    
    // MARK - Drawing methods
    fileprivate func resetBricks() {
        // draw bricks
        numberOfBricks = numberOfRows * bricksPerRow
        for row in 1...numberOfRows {
            for col in 1...bricksPerRow {
                _ = addBrick(row: row, col: col)
            }
        }
    }
    fileprivate func resetBall() {
        // draw ball
        let ball_frame = CGRect(center: CGPoint(x: bounds.size.width / 2, y: bounds.height - CGFloat(self.paddleHeight) - ballRadius),
                                size: CGSize(width: 2*ballRadius, height: 2*ballRadius))
        ball = UIView(frame: ball_frame)
    }
    func resetGame() {
        resetBricks()
        resetBall()
        bumpingBehavior.addItem(ball)
        addSubview(ball)
        // draw paddle
        let bs = brickSize
        let paddle_frame = CGRect(center: CGPoint(x: bounds.size.width / 2, y: bounds.height - CGFloat(self.paddleHeight)),
                           size: CGSize(width: bs.width * 1.5, height: bs.height/2))
        paddle = UIBezierPath(rect: paddle_frame)
    }
    
    fileprivate func addBrick(row: Int, col: Int) -> UIBezierPath {
        // get origin
        let size = brickSize
        let origin = CGPoint(x: (CGFloat(col)/CGFloat(intervalWidthRatio) + CGFloat(col-1)) * size.width,
                             y: (CGFloat(row)/CGFloat(intervalHeightRatio) + CGFloat(row-1)) * size.height)
        let frame = CGRect(origin: origin, size: brickSize)
        let brick = UIBezierPath(rect: frame)
        let name = PathNames.brickBarrier+String(row)+String(col)
        bezierPaths[name] = brick
        fillColors[name] = UIColor.blue
        bumpingBehavior.addBarrier(brick, named: name)
        return brick
    }
    
    fileprivate struct PathNames {
        static let brickBarrier = "Brick Barrier"
        static let paddleBarrier = "Paddle Barrier"
    }
    
    // MARK - Animating
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(bumpingBehavior)
            } else {
                animator.removeBehavior(bumpingBehavior)
            }
        }
    }
    
    fileprivate lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    fileprivate lazy var bumpingBehavior: BreakoutBehavior = {
        let bumpingBehavior = BreakoutBehavior(collisionDelegate: self)
        return bumpingBehavior
    }()
    
    func addImpulse(_ recognizer: UITapGestureRecognizer) {
        bumpingBehavior.pushBall(self.ball)
    }
    
    func movePaddle(_ recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.location(in: self)
        let translation = recognizer.translation(in: self)
        switch recognizer.state {
        case .changed:
            if gesturePoint.y < bounds.height/2 {
                break
            }
            let bs = brickSize
            let size = CGSize(width: bs.width * 1.5, height: bs.height/2)
            var centerX = paddle.bounds.minX + size.width/2 + translation.x
            if (centerX < size.width/2) {
                centerX = size.width/2
            } else if (centerX > (bounds.size.width - size.width/2)) {
                centerX = bounds.width - size.width/2
            }
            let paddle_frame = CGRect(center: CGPoint(x: centerX, y: bounds.height - CGFloat(self.paddleHeight)),
                                      size: size)
            paddle = UIBezierPath(rect: paddle_frame)
            recognizer.setTranslation(CGPoint(), in: self)
        default:
            break
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let stringName = identifier as? String, stringName.hasPrefix(PathNames.brickBarrier) {
            behavior.removeBoundary(withIdentifier: identifier!)
            bezierPaths.removeValue(forKey: (identifier as? String)!)
            self.numberOfBricks = self.numberOfBricks - 1
        }
    }
    
}
