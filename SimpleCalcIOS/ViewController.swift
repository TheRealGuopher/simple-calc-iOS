//
//  ViewController.swift
//  SimpleCalcIOS
//
//  Created by JJ Guo on 1/25/18.
//  Copyright © 2018 JJ Guo. All rights reserved.
//

import UIKit

enum Operation:String {
    case Add = "+"
    case Subtract = "-"
    case Multiply = "*"
    case Divide = "/"
    case NULL = "Null"
    case Avg
    case Count
    case Fact
}

class ViewController: UIViewController {

    @IBOutlet weak var outputLbl: UILabel!
    
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation:Operation = .NULL
    var count = 0
    var sum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputLbl.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numberPressed(_ sender: RoundButton) { // everytime number is pressed, this adds to runningNumber
        if runningNumber.count <= 8 {
            runningNumber += "\(sender.tag)"
            outputLbl.text = runningNumber
        }
    }
    @IBAction func allClearPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
        outputLbl.text = "0"
    }
    @IBAction func dotPressed(_ sender: RoundButton) {
        if runningNumber.count <= 7 && !runningNumber.contains("."){
            runningNumber += "."
            outputLbl.text = runningNumber
        }
    }
    @IBAction func equalPressed(_ sender: RoundButton) {
        if currentOperation == .Count {
            specialOperation(operation: currentOperation)
        }
        operation(operation: currentOperation)
    }
    @IBAction func addPressed(_ sender: RoundButton) {
        operation(operation: .Add)
    }
    @IBAction func subtractPressed(_ sender: RoundButton) {
        operation(operation: .Subtract)
    }
    @IBAction func multiplyPressed(_ sender: RoundButton) {
        operation(operation: .Multiply)
    }
    @IBAction func dividePressed(_ sender: RoundButton) {
        operation(operation: .Divide)
    }
    @IBAction func avgPressed(_ sender: RoundButton) {
        
    }
    @IBAction func countPressed(_ sender: RoundButton) {
        currentOperation = .Count
        operation(operation: .Count)
    }
    @IBAction func factPressed(_ sender: RoundButton) {
    }
    
    // make fact, avg, count separate func. Start at 0 or 1.
    // make sure to check if leftValue/rightValue are empty or not empty, all the mutha fucking combos
    // . + 3 doesn't break code
    // Operations with just the dot, only treat it if there's numbers available
    
    func specialOperation(operation: Operation) {
        if runningNumber == "" {
            result = "\(count)"
        } else {
            result = "\(count + 1)"
        }
        runningNumber = ""
        outputLbl.text = result
        count = 0
    }
    
    func operation(operation: Operation) {
        if currentOperation == .Avg || currentOperation == .Count || currentOperation == .Fact {
            if runningNumber != "" {
                leftValue = runningNumber
                runningNumber = ""
                count += 1
            }
            
//            if leftValue != runningNumber {
//                leftValue = runningNumber
//                runningNumber = ""
//                result = "\(count + 1)"
//                outputLbl.text = result
//                count = 0
//            }
        } else if currentOperation != .NULL {
            if runningNumber != "" && leftValue != "" {
                rightValue = runningNumber
                runningNumber = ""
                
                if currentOperation == .Add {
                    result = "\(Double(leftValue)! + Double(rightValue)!)"
                } else if currentOperation == .Subtract {
                    result = "\(Double(leftValue)! - Double(rightValue)!)"
                } else if currentOperation == .Multiply {
                    result = "\(Double(leftValue)! * Double(rightValue)!)"
                } else if currentOperation == .Divide {
                    result = "\(Double(leftValue)! / Double(rightValue)!)"
                }
                
                leftValue = result
                if (Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
                    result = "\(Int(Double(result)!))"
                }
                outputLbl.text = result
            }
            if runningNumber != "" && leftValue == "" {
                leftValue = runningNumber
                runningNumber = ""
            }
            currentOperation = operation
        } else { // "8 +" or "+"
            leftValue = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
}

