//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Miguel Garcia on 11/14/16.
//  Copyright © 2016 GCC. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var accumulator: Double = 0.0
    private var descriptionAccumulator = "0"
    var result: Double{ get{ return accumulator } }
    
    var isPartialResult: Bool = false
    
    var description: String{
        get{
            if pending == nil{
                return descriptionAccumulator
            } else {
                return ""
            }
        }
    }
    
    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : .Constant(M_PI),
        "e" : .Constant(M_E),
        "±" : .UnaryOperation({ -$0}),
        "√" : .UnaryOperation(sqrt),
        "cos" : .UnaryOperation(cos),
        "sin" : .UnaryOperation(sin),
        "tan" : .UnaryOperation(tan),
        "log" : .UnaryOperation(log),
        "x²": .UnaryOperation({$0 * $0}),
        "x⁻¹": .UnaryOperation({1/$0}),
        "+" : .BinaryOperation({$0 + $1}),
        "−" : .BinaryOperation({$0 - $1}),
        "×" : .BinaryOperation({$0 * $1}),
        "÷" : .BinaryOperation({$1 / $0}),
        "=" : .Equals
    ]
    
    struct PendingBinaryOperationInfo {
        var firstOperand: Double
        var binaryFunction: (Double, Double) -> Double
//        var descriptionFunction: (String, String) -> String
//        var descriptionAccumulator: (String) -> String
    }
    
    private var pending: PendingBinaryOperationInfo?    //2
    
    // Intended to be Double if it is an operand
    // String if it is an operations
    private var internalProgram = [AnyObject]()
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                isPartialResult = true
                executePendingbinaryOperation()
                pending = PendingBinaryOperationInfo(firstOperand: accumulator,
                                                     binaryFunction: function)
            case .Equals:
                executePendingbinaryOperation()
            }
        }
    }
    
    func executePendingbinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(accumulator, pending!.firstOperand)
            pending = nil
            isPartialResult = false
        }
    }
    
    func setOperand(operand: Double){
        accumulator = operand
        descriptionAccumulator = String(operand)
        internalProgram.append(operand as AnyObject)
    }
    
    var variableValues: Dictionary<String, Double> = [:]
    
    func setOperator(operand: String){
        variableValues[operand] = 0.0
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList{
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayofOps = newValue as? [PropertyList] {
                for op in arrayofOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    }
                    else if let operand = op as? String {
                        performOperation(symbol: operand)
                    }
                }
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
}
