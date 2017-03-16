//
//  ViewController.swift
//  Calculator
//
//  Created by Nathan on 29/01/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var brain = CalculatorBrain()
    @IBOutlet weak var Status: UILabel!
    @IBOutlet private weak var Display: UILabel!
    private var IfStartTyping = false
    private var savedState = false
    
    private func showDescription(){
        if IfStartTyping{
            Status.text = brain.description
        }
        if brain.isPartialResult{
            Status.text = brain.description + "..."
        }
        else{
            Status.text = brain.description + "="
        }
    }
    
    
    @IBAction private func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        switch digit{
            case "Del":
                if IfStartTyping{
                    displayValue = 0
                    IfStartTyping = false
                }
                else{
                    goToBack()
            }
            case "→M":
                brain.variableValues["M"] = Double(Display.text!)!
                displayValue = 0
                IfStartTyping = false
                Status.text = ""
                brain.description = ""
                brain.clear()
            case "C":
                displayValue = 0
                IfStartTyping = false
                Status.text = ""
                brain.description = ""
                brain.clear()
        default:
            if IfStartTyping{
                let textCurrentlyInDisplay = Display.text!
                Display.text = textCurrentlyInDisplay + digit
            }
            else{
                Display.text = digit
            }
            IfStartTyping = true
        }
        showDescription();
    }
    
    private var displayValue: Double {
        get{
            return Double(Display.text!)!
        }
        set{
            Display.text = String(newValue)
        }
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if IfStartTyping == true{
            if(Display.text == "M")
            {
                brain.setOperand(variableName: "M")
                IfStartTyping = false
            }
            else{
                brain.setOperand(operand: displayValue)
                IfStartTyping = false
            }
        }
        if let mathematicalSymbl = sender.currentTitle{
            backup(IfStartTyping) // back up
            brain.performOperation(symbol: mathematicalSymbl)
        }
        displayValue = brain.result
        showDescription()
        
        if( brain.description[description.startIndex] == "√"){ //for restart the description when end with "√" performance /*To Be improved here */
            brain.description = ""
        }
        
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    var backupProgram: CalculatorBrain.PropertyList?
    
    func backup(_ ifStartTyping: Bool){
        backupProgram = brain.delProgram as CalculatorBrain.PropertyList?
        savedState = IfStartTyping
    }
    
    func goToBack(){
        IfStartTyping = savedState
        if backupProgram != nil{
            brain.program = backupProgram!
            displayValue = brain.result
            showDescription()
        }
    }
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil{
            brain.program = savedProgram!
            displayValue = brain.result
            showDescription()
        }
    }
    
}
