//
//  NamedBezierPathsView.swift
//  Bumping
//
//  Created by Xingan Wang on 10/1/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class NamedBezierPathsView: UIView {

    var bezierPaths = [String:UIBezierPath]() { didSet { setNeedsDisplay() } }
    var fillColors = [String:UIColor]() { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        for (name,path) in bezierPaths {
            (fillColors[name] ?? UIColor.blue).setFill()
            path.fill()
            path.stroke()
        }
    }

}
