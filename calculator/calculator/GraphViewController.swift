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
    var axesOriginOffsetToCenter: CGPoint
    var function: CalculatorBrain.PropertyList?
}

class GraphViewController: UIViewController {
    
    // MARK: - Model
    var graphModel = GraphModel(axesPointsPerUnit: 50.0, axesOriginOffsetToCenter: CGPoint(), function: nil) {
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
            
            let doubleTapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(GraphViewController.moveOriginTo(_:))
            )
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapGestureRecognizer)
            
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
        switch recognizer.state {
        case .Changed, .Ended:
            let trans = recognizer.translationInView(graphView)
            graphView.axesOriginOffsetToCenter.x += trans.x
            graphView.axesOriginOffsetToCenter.y += trans.y
            break
        default:
            break
        }
    }
    
    func moveOriginTo(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .Ended:
            let touchPos = recognizer.locationInView(graphView)
            graphView.axesOriginOffsetToCenter = CGPoint(
                x: touchPos.x - graphView.bounds.width/2,
                y: touchPos.y - graphView.bounds.height/2
            )
            break
        default:
            break
        }
    }
    
    
    private func _updateUI() {
        if (graphView != nil) {
            graphView.axesPointsPerUnit = graphModel.axesPointsPerUnit
            graphView.function = graphModel.function
        }
    }

}
