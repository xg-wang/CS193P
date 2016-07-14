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
}

class GraphViewController: UIViewController {
    
    // MARK: - Model
    var graphModel = GraphModel(axesPointsPerUnit: 50.0) {
        didSet{
            _updateUI()
        }
    }
    
    // MARK: - View
    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var graphNavItem: UINavigationItem!
    @IBOutlet weak var graphView: GraphView! {
        didSet{
            _updateUI()
        }
    }
    
    // MARK: - Controlls
    override func viewWillAppear(animated: Bool) {
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    }
    private func _updateUI() {
        if (graphView != nil) {
            graphView.axesPointsPerUnit = graphModel.axesPointsPerUnit
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
