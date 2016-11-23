//
//  ViewController.swift
//  Calculator
//
//  Created by Miguel Garcia on 11/14/16.
//  Copyright © 2016 GCC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var brain: CalculatorBrain = CalculatorBrain()
    private var userIsInTheMiddleOfTyping: Bool = false

    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var displayDescription: UILabel!
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle! //1
        if (userIsInTheMiddleOfTyping && digit != ".") ||
            (digit == "." && (display.text!.range(of: ".") == nil)){
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            if digit == "." {
                display.text =  "0" + digit
            } else {
                display.text = digit
            }
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue : Double {
        get {
            //! optional: we have to account for every string passed
            return Double(display.text!)!
        }
        set {
            //Double can always be converted to a string
            display.text = String(newValue)
        }
    }
    
    @IBAction private func performOperation(_ sender: UIButton){
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let matematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: matematicalSymbol)
        }
        displayValue = brain.result
    }
    
    var saveProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        saveProgram = brain.program
    }
    
    @IBAction func restore() {
        if saveProgram != nil {
            brain.program = saveProgram!
            displayValue = brain.result
        }
    }
 
    @IBAction func clearButton() {
        userIsInTheMiddleOfTyping = false
        brain.clear()
        displayValue = brain.result
    }
}
//1 Optionals are allways initiallize to nil
//1 Current title is an optional. Its associated value is a string
//2 Print("Touched key \(digit)") for debuggin purposes
//3 We do not have to unwrap to set the value of a variable.
//  Specifictly, we are saying set this optional to set state with
//  an associate value of textCurrentlyInDisplay + digit
//4 Display is always set after the first nanosecond of activating the app.
//  This is the reason why we unwrap the optional at the begining of the exectution

