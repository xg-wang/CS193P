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
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: self, action: #selector(GraphViewController.changeScale(_:))
            ))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(
                target: self, action: #selector(GraphViewController.moveGraph(_:))
            ))
            _updateUI()
        }
    }
    
    // MARK: Gesture handlers
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            graphView.axesPointsPerUnit *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    func moveGraph(recognizer: UIPanGestureRecognizer) {
        
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
