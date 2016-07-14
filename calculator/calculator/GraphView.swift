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
    var axesOrigin: CGPoint = CGPoint() {
        didSet {
            originSet = true
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var axesPointsPerUnit: CGFloat = 50.0 { didSet { setNeedsDisplay() } }

    
    // Helper Drawer
    private var axesDrawer = AxesDrawer()
    
    private var originSet = false

    override func drawRect(rect: CGRect) {
        // Drawing code
        let originToDraw = originSet ?
            axesOrigin :
            CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        axesDrawer.drawAxesInRect(self.bounds, origin: originToDraw, pointsPerUnit: axesPointsPerUnit)
    }

}
