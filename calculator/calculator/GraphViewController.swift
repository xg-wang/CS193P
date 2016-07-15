//
//  GraphViewController.swift
//  calculator
//
//  Created by Xingan Wang on 7/10/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

struct GraphModel {
    var axesPointsPerUnit: CGFloat
    var function: CalculatorBrain.PropertyList?
}

class GraphViewController: UIViewController {
    
    // MARK: - Model
    var graphModel = GraphModel(axesPointsPerUnit: 50.0, function: nil) {
        didSet{
            _updateUI()
        }
    }
    
    // MARK: - View
    @IBOutlet weak var graphView: GraphView! {
        didSet{
            _updateUI()
        }
    }
    
    // MARK: - Controllers
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
    }
    private func _updateUI() {
        if (graphView != nil) {
            graphView.axesPointsPerUnit = graphModel.axesPointsPerUnit
            graphView.function = graphModel.function
        }
    }

}
