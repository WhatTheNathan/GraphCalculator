//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nathan on 30/01/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation


class CalculatorBrain{ //model
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]() //the array ofAnyObjet
    var delProgram = [AnyObject]()
    private var pending: PendingBianryOperationInfo?
    
    var description : String = ""
    var isPartialResult : Bool{
        get{
            if pending != nil{
                return true
            }
            else{
                return false
            }
        }
    }
    
    func setOperand(variableName: String){
        if let operand = variableValues[variableName]{
            accumulator = operand
            internalProgram.append(operand as AnyObject)
            delProgram.append(operand as AnyObject)
            description += variableName
        }
    }
    
    var variableValues: Dictionary<String, Double> = [
        "M" : 0
    ]
    
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
        delProgram.append(operand as AnyObject)
        description += String(operand)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({-$0}),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "✕" : Operation.BinaryOperation({$0 * $1}), //closures
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double) //represent function
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        delProgram.append(symbol as AnyObject)
        if let operation = operations[symbol]{
            switch operation{ //Swift can inferOperation
            case .Constant(let value):
                accumulator = value
                description += symbol
                
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                if isPartialResult{
                    let index = description.index(description.endIndex, offsetBy: -3)
                    description.insert("√", at: index)// at last operand /*To Be improved here */
                }
                else{
                    description = "√(" + description + ")"
                }
                
            case .BinaryOperation(let function):
                executePedingBinaryOperation()//for continued multiply
                pending = PendingBianryOperationInfo(binaryFunction: function,firstOperand: accumulator)
                description += symbol
                
            case .Equals:
                let index = description.index(description.endIndex, offsetBy: -1)
                if description[index] == "+"{
                    description += String(accumulator)
                }
                executePedingBinaryOperation()
            }
        }
    }
    
    private func executePedingBinaryOperation(){
        if pending != nil{
//            description += String(pending!.firstOperand)
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    
    private struct PendingBianryOperationInfo{
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var stateProgram: PropertyList{
        get{
            return delProgram as CalculatorBrain.PropertyList
        }
        set{//code redundancy   /*To Be improved here */
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }
                    else if let operation = op as? String{
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    var program: PropertyList{
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }
                    else if let operation = op as? String{
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear(){
        description = ""
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
        delProgram.removeAll()
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
}
