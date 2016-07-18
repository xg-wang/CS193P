//
//  ViewController.swift
//  calculator
//
//  Created by Xingan Wang on 6/10/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private var _formatter = NSNumberFormatter()
    
    private var userIsTyping = false
    
    private var digitIndecimalpoint = false
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak private var display: UILabel!
    @IBOutlet weak var drawGraphBtn: UIButton!
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." {
            if digitIndecimalpoint {
                return
            } else if userIsTyping{
                display.text! += digit
                digitIndecimalpoint = true
            } else {
                display.text = "0."
                digitIndecimalpoint = true
                userIsTyping = true
            }
        }
        else if userIsTyping && display.text != "0" {
            display.text! += digit
        } else {
            display.text = digit
            userIsTyping = true
        }
        _update()
    }

    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            _formatter.maximumFractionDigits = 6
            _formatter.minimumIntegerDigits = 1
            display.text = _formatter.stringFromNumber(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
            digitIndecimalpoint = false
        }
        if let symbol = sender.currentTitle {
            brain.operate(symbol)
        }
        displayValue = brain.result
        _update()
    }
    
    // TODO: reduce this!
    @IBAction func callMemory(sender: UIButton) {
        performOperation(sender)
    }
    @IBAction func setMemory(sender: UIButton) {
        // set these to false to avoid setting operand again
        userIsTyping = false
        digitIndecimalpoint = false
        // set variable value to current display
        var varName = sender.currentTitle!
        if varName.hasPrefix("→") {
            varName.removeAtIndex(varName.startIndex)
        }
        brain.variableValues[varName] = displayValue
        // shows the brain’s result in the display.
        displayValue = brain.result
        _update()
    }
    
    
    private func _update() {
        let brainDescString = brain.description
        if brainDescString.isEmpty {
            desc.text = " "
        } else {
            desc.text = brainDescString + (brain.isPartialResult ? "..." : " =")
        }
        drawGraphBtn.enabled = !brain.isPartialResult
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var descv = segue.destinationViewController
        if let navcon = descv as? UINavigationController {
            descv = navcon.visibleViewController ?? descv
        }
        if let graphvc = descv as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "ShowGraph":
                    let function: CalculatorBrain.PropertyList? = brain.isPartialResult ? nil : brain.program
                    let description = brain.isPartialResult ? " " : brain.description
                    graphvc.graphModel.function = function
                    graphvc.navigationItem.title = description
                default:
                    break
                }
            }
        }
    }
    
}

