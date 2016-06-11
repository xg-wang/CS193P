//
//  ViewController.swift
//  calculator
//
//  Created by Xingan Wang on 6/10/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userIsTyping = false
    private var digitIndecimalpoint = false
    
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
        else if userIsTyping {
            display.text! += digit
        } else {
            display.text = digit
            userIsTyping = true
        }
    }

    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
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
    }
    
}

