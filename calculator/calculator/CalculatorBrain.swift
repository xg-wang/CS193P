//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Xingan Wang on 6/10/16.
//  Copyright © 2016 Xingan Wang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    init() {
        _formatter.maximumFractionDigits = 6
        _formatter.minimumFractionDigits = 0
        _formatter.minimumIntegerDigits = 1
    }
    
    private var _formatter = NSNumberFormatter()
    
    private var _internalProgram = [AnyObject]()
    
    private var _accumulator = 0.0
    
    private var _descArray = [String]()
    
    var description: String {
        var ret = ""
        for desc in _descArray {
            ret += desc
        }
        return ret
    }
    
    /**
        - Returns **true** if there is pendingInfo
    */
    var isPartialResult: Bool {
        return pendingInfo != nil
    }
    
    func setOperand(variableName: String) {
        // set variable as 0.0 if not exists
        let variable = variableValues[variableName] ?? 0.0
        _accumulator = variable
        if pendingInfo == nil {
            _descArray.removeAll()
        }
        _descArray.append(variableName)
    }
    var variableValues: Dictionary<String, Double> = [:] {
        // refresh to utilize the newly set variable
        didSet{
            program = _internalProgram
        }
    }
    
    func setOperand(operand: Double) {
        _accumulator = operand
        _internalProgram.append(operand)
        if pendingInfo == nil {
            _descArray.removeAll()
        }
        _descArray.append(_formatter.stringFromNumber(operand)!)
    }
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
        case Save
        case Restore
        case CallMemory(String)
    }
    
    private var operationDic: Dictionary<String, Operation> = [
        "π"     : Operation.Constant(M_PI),
        "e"     : Operation.Constant(M_E),
        "sin"   : Operation.UnaryOperation(sin),
        "tan"   : Operation.UnaryOperation(tan),
        "^2"    : Operation.UnaryOperation({ $0 * $0 }),
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
        "R"     : Operation.Restore,
        "M"     : Operation.CallMemory("M")
    ]
    
    func operate(symbol : String) {
        _internalProgram.append(symbol)
        if let operation = operationDic[symbol] {
            switch operation {
            case .Constant(let cons):
                _accumulator = cons
                _descArray.append(symbol)
            case .UnaryOperation(let foo):
                _accumulator = foo(_accumulator)
                if pendingInfo != nil {
                    _descArray.insert(symbol, atIndex: _descArray.endIndex-1)
                    _descArray.insert("(", atIndex: _descArray.endIndex-1)
                    _descArray.append(")")
                } else {
                    _descArray.insert(symbol, atIndex: 0)
                    _descArray.insert("(", atIndex: 1)
                    _descArray.append(")")
                }
            case .BinaryOperation(let foo):
                executePendingOperation()
                pendingInfo = PendingBinaryOperation(binaryFunc: foo,
                                                     firstOperand: _accumulator)
                _descArray.append(symbol)
            case .Equals:
                executePendingOperation()
            case .Clear:
                clear()
            case .Save:
                savedProgram = program
            case .Restore:
                program = savedProgram!
            case .CallMemory(let variable):
                setOperand(variable)
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
            // when two continuous operation occurs, 
            // append the accumulator again.
            let endSymbol = _descArray[_descArray.endIndex-1]
            if endSymbol != ")" && endSymbol != "M" && Double(endSymbol) == nil {
                if let operation = operationDic[endSymbol] {
                    switch operation {
                    case .Constant:
                        break
                    default:
                        _descArray.append(_formatter.stringFromNumber(_accumulator)!)
                    }
                }
            }
            _accumulator = pendingInfo!.binaryFunc(pendingInfo!.firstOperand,
                                                  _accumulator)
            pendingInfo = nil
        }
    }
    
    typealias PropertyList = AnyObject
    
    private var savedProgram: PropertyList?
    
    var program: PropertyList {
        get {
            return _internalProgram
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
        _accumulator = 0.0
        pendingInfo = nil
        _internalProgram.removeAll()
        _descArray.removeAll()
    }
    
    var result: Double {
        get {
            return _accumulator
        }
    }
}