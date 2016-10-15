//
//  BumpingViewController.swift
//  Bumping
//
//  Created by Xingan Wang on 10/1/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class BumpingViewController: UIViewController {

    @IBOutlet weak var gameView: BumpingView! {
        didSet {
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: gameView, action: #selector(BumpingView
                .addImpulse(_:))))
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(BumpingView.movePaddle(_:))))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameView.resetGame()
    }
    
    // only auto rotate when not started
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameView.animating = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
