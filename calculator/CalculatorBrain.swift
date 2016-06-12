//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Xingan Wang on 6/10/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accumulator = 0.0
    
    func setOperand(operand : Double) {
        accumulator = operand
    }
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var operationDic: Dictionary<String, Operation> = [
        "π"     : Operation.Constant(M_PI),
        "e"     : Operation.Constant(M_E),
        "sin"   : Operation.UnaryOperation(sin),
        "cos"   : Operation.UnaryOperation(cos),
        "tan"   : Operation.UnaryOperation(tan),
        "√"     : Operation.UnaryOperation(sqrt),
        "±"     : Operation.UnaryOperation({ -$0 }),
        "%"     : Operation.BinaryOperation({ $0 % $1 }),
        "÷"     : Operation.BinaryOperation({ $0 / $1 }),
        "×"     : Operation.BinaryOperation({ $0 * $1 }),
        "−"     : Operation.BinaryOperation({ $0 - $1 }),
        "+"     : Operation.BinaryOperation({ $0 + $1 }),
        "="     : Operation.Equals
    ]
    
    func operate(symbol : String) {
        if let operation = operationDic[symbol] {
            switch operation {
            case .Constant(let cons):
                accumulator = cons
            case .UnaryOperation(let foo):
                accumulator = foo(accumulator)
            case .BinaryOperation(let foo):
                executePendingOperation()
                pendingInfo = PendingBinaryOperation(binaryFunc: foo, firstOperand: accumulator)
            case .Equals:
                executePendingOperation()
            }
        }
    }
    
    private struct PendingBinaryOperation {
        var binaryFunc: (Double, Double) -> (Double)
        var firstOperand: (Double)
    }
    private var pendingInfo: PendingBinaryOperation?
    
    private func executePendingOperation() {
        if pendingInfo != nil {
            accumulator = pendingInfo!.binaryFunc((pendingInfo!.firstOperand), accumulator)
            pendingInfo = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}