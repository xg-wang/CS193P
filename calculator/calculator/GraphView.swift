//
//  GraphView.swift
//  calculator
//
//  Created by Xingan Wang on 7/12/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    // MARK: Public API
    @IBInspectable
    var axesOriginOffsetToCenter: CGPoint = CGPoint() { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var axesPointsPerUnit: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    
    var function: CalculatorBrain.PropertyList? {
        didSet {
            if function != nil {
                brain.program = function!
            }
            setNeedsDisplay()
        }
    }
    
    // MARK: Private implementation
    private var brain = CalculatorBrain()
    
    private var axesDrawer = AxesDrawer()
    
    private func pathforFunction(origin: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        if function != nil {
            // draw per pixel
            let w = Int(floor(self.bounds.width))
            let originXbyPixel = Int(floor(origin.x))
            var lastY: CGFloat
            
            brain.variableValues["M"] = Double(Double(0 - originXbyPixel) / Double(axesPointsPerUnit))
            lastY = origin.y - CGFloat(brain.result) * axesPointsPerUnit
            let start = CGPoint(x: 0.0, y: lastY)
            path.moveToPoint(start)
            
            for i in 1..<w {
                brain.variableValues["M"] = Double(Double(i - originXbyPixel) / Double(axesPointsPerUnit))
                let currY = origin.y - CGFloat(brain.result) * axesPointsPerUnit
                let currPoint = CGPoint(x: CGFloat(i), y: currY)
                if !(lastY < self.bounds.minY || lastY > self.bounds.maxY
                    && abs(Double(currY - lastY)) > Double(self.bounds.height))  {
                    path.addLineToPoint(currPoint)
                }
                path.moveToPoint(currPoint)
                lastY = currY
            }
            path.lineWidth = lineWidth
        }
        return path
    }
    
    private var originSet = false

    override func drawRect(rect: CGRect) {
        // Drawing code
        let axesOrigin = CGPoint(
            x: self.bounds.width/2 + axesOriginOffsetToCenter.x,
            y: self.bounds.height/2 + axesOriginOffsetToCenter.y
        )
        axesDrawer.drawAxesInRect(self.bounds, origin: axesOrigin, pointsPerUnit: axesPointsPerUnit)
        pathforFunction(axesOrigin).stroke()
    }

}
