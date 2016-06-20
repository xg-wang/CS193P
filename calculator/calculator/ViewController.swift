//
//  ViewController.swift
//  calculator
//
//  Created by Xingan Wang on 6/10/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var _formatter = NSNumberFormatter()
    
    private var userIsTyping = false
    
    private var digitIndecimalpoint = false
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak private var display: UILabel!
    
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
    
    private func _update() {
        if brain.description.isEmpty {
            desc.text = " "
        } else {
            desc.text = brain.description + (brain.isPartialResult ? "..." : " =")
        }
    }
    
}

