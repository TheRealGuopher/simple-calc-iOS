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
    case Mod = "%"
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
        if currentOperation == .Count || currentOperation == .Avg || currentOperation == .Fact {
            specialOperation(operation: currentOperation)
        } else {
            operation(operation: currentOperation)
        }
    }
    @IBAction func addPressed(_ sender: RoundButton) {
        currentOperation = .Add
        operation(operation: .Add)
    }
    @IBAction func subtractPressed(_ sender: RoundButton) {
        currentOperation = .Subtract
        operation(operation: .Subtract)
    }
    @IBAction func multiplyPressed(_ sender: RoundButton) {
        currentOperation = .Multiply
        operation(operation: .Multiply)
    }
    @IBAction func dividePressed(_ sender: RoundButton) {
        currentOperation = .Divide
        operation(operation: .Divide)
    }
    @IBAction func modPressed(_ sender: RoundButton) {
        currentOperation = .Mod
        operation(operation: .Mod)
    }
    @IBAction func avgPressed(_ sender: RoundButton) {
        currentOperation = .Avg
        operation(operation: currentOperation)
    }
    @IBAction func countPressed(_ sender: RoundButton) {
        currentOperation = .Count
        operation(operation: currentOperation)
    }
    @IBAction func factPressed(_ sender: RoundButton) {
        currentOperation = .Fact
        operation(operation: currentOperation)
    }
    
    // make sure to check if leftValue/rightValue are empty or not empty, all the mutha fucking combos
    // . + 3 doesn't break code
    // Operations with just the dot, only treat it if there's numbers available
    
    func specialOperation(operation: Operation) { // equals pressed
        if operation == .Count {
            if runningNumber == "" {
                result = "\(count)"
            } else {
                result = "\(count + 1)"
            }
            leftValue = result
            runningNumber = ""
            outputLbl.text = result
            count = 0
        } else {
            if runningNumber == "" {
                result = "\(Double(sum) / Double(count))"
            } else {
                count += 1
                sum += Int(runningNumber)!
                result = "\(Double(sum) / Double(count))"
            }
            leftValue = result
            if (Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
                result = "\(Int(Double(result)!))"
            }
            runningNumber = ""
            outputLbl.text = result
            count = 0
            sum = 0
        }
    }
    
    func operation(operation: Operation) {
        if currentOperation == .Count {
            if runningNumber != "" {
                leftValue = runningNumber
                runningNumber = ""
                count += 1
            }
        } else if currentOperation == .Fact {
            if runningNumber != "" && Int(runningNumber)! >= 0 && Double(runningNumber)!.truncatingRemainder(dividingBy: 1) == 0 {
                var prod = 1
                var num = Int(runningNumber)!
                var success = true
                while num > 1 {
                    if (prod * num < 2147483647) {
                        prod *= num
                        num -= 1
                    } else {
                        success = false
                        outputLbl.text = "too big"
                        break
                    }
                }
                if success {
                    result = String(prod)
                    leftValue = result
                    runningNumber = ""
                    outputLbl.text = result
                } else {
                    leftValue = runningNumber
                    result = runningNumber
                }
                runningNumber = ""
            } else if leftValue != "" && Int(leftValue)! >= 0 && Double(leftValue)!.truncatingRemainder(dividingBy: 1) == 0 {
                var prod = 1
                var num: Int = Int(leftValue)!
                while num > 1 {
                    if (prod * num < 2147483647) {
                        prod *= num
                        num -= 1
                    } else {
                        break
                    }
                }
                result = String(prod)
                leftValue = result
                runningNumber = ""
                outputLbl.text = result
            }
        } else if currentOperation == .Avg {
            if runningNumber != "" {
                sum += Int(runningNumber)!
                leftValue = runningNumber
                runningNumber = ""
                count += 1
            } else if leftValue != "" {
                sum += Int(leftValue)!
                runningNumber = ""
                count += 1
            }
            else if count > 0 {
                specialOperation(operation: .Avg)
            }
        } else if currentOperation != .NULL {
            if runningNumber != "" && leftValue != "" && runningNumber != "." {
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
                } else if currentOperation == .Mod {
                    let times = Int(leftValue)! / Int(rightValue)!
                    result = "\(Int(leftValue)! - (times * Int(rightValue)!))"
                }
                
                if (Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
                    result = "\(Int(Double(result)!))"
                }
                leftValue = result
                outputLbl.text = result
            }
            if runningNumber != "" && leftValue == "" && runningNumber == "." {
                leftValue = ""
                runningNumber = ""
            } else if runningNumber != "" && leftValue == "" {
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

