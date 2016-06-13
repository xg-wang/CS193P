//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Xingan Wang on 6/10/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var internalProgram = [AnyObject]()
    
    private var accumulator = 0.0
    
    func setOperand(operand : Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
        case Save
        case Restore
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
        "="     : Operation.Equals,
        "AC"    : Operation.Clear,
        "S"     : Operation.Save,
        "R"     : Operation.Restore
    ]
    
    // avoid double touch + to execute twice
    private var lastIsBinaryOp = false
    
    func operate(symbol : String) {
        internalProgram.append(symbol)
        if let operation = operationDic[symbol] {
            switch operation {
            case .Constant(let cons):
                accumulator = cons
            case .UnaryOperation(let foo):
                accumulator = foo(accumulator)
            case .BinaryOperation(let foo):
                executePendingOperation()
                pendingInfo = PendingBinaryOperation(binaryFunc: foo,
                                                     firstOperand: accumulator)
            case .Equals:
                executePendingOperation()
            case .Clear:
                clear()
            case .Save:
                savedProgram = program
            case .Restore:
                program = savedProgram!
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
            accumulator = pendingInfo!.binaryFunc(pendingInfo!.firstOperand,
                                                  accumulator)
            pendingInfo = nil
        }
    }
    
    typealias PropertyList = AnyObject
    
    private var savedProgram: PropertyList?
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        operate(operation)
                    }
                }
            }
        }
    }
    
    private func clear() {
        accumulator = 0.0
        pendingInfo = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}