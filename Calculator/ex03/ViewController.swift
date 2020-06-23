//
//  ViewController.swift
//  ex02
//
//  Created by Mishchenko YULIIA on 9/30/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var firstNumber: Double = 0
    var secondNumber: Double = 0
    var Result_num: Double = 0
    var mathSign: Bool = false
    var sign: Int = 0
    var wait: Bool = false
    @IBOutlet weak var result: UILabel!
    
    @IBAction func Clear(_ sender: UIButton) {
        firstNumber = 0
        mathSign = false
        sign = 0
        Result_num = 0
        result.text = ""
        wait = false
        print ("AC")
    }
    @IBAction func digets(_ sender: UIButton) {
        if (mathSign == true){
            result.text = String(sender.tag)
            mathSign = false}
        else {
            result.text = result.text! + String(sender.tag)}
        
        
        print (String(sender.tag))
    }
    
    @IBAction func operand(_ sender: UIButton) {
        if (wait == true && sender.tag != 15 && sender.tag != 16)
        {
            secondNumber = Double(result.text!)!
            if (sign == 11 && secondNumber != 0){
                Result_num = firstNumber / secondNumber }
            else if (sign == 12){
                Result_num = firstNumber * secondNumber }
            else if (sign == 13){
                Result_num = firstNumber - secondNumber }
            else if (sign == 14){
                Result_num = firstNumber + secondNumber }
            result.text = String(Result_num)
            firstNumber = Result_num
            sign = 0
            wait = false
        }
        if (result.text != "" && sender.tag != 15 && sender.tag != 16)
        {
            firstNumber = Double(result.text!)!
            if (sender.tag == 11){
                sign = 11
                print ("division")}
            else if (sender.tag == 12){
                sign = 12
                print ("multiplication")}
            else if (sender.tag == 13){
                sign = 13
                print ("minus")}
            else if (sender.tag == 14){
                sign = 14
                print ("plus")}
            mathSign = true
            wait = true
        }
        else if (sender.tag == 15){
            secondNumber = Double(result.text!)!
            if (sign != 0)
            {
                 if (sign == 11 && secondNumber != 0){
                    Result_num = firstNumber / secondNumber }
                else if (sign == 12){
                        Result_num = firstNumber * secondNumber }
                else if (sign == 13){
                        Result_num = firstNumber - secondNumber }
                else if (sign == 14){
                        Result_num = firstNumber + secondNumber }
            }
            result.text = String(Result_num)
            sign = 0
        }
        else if (sender.tag == 16 && result.text != ""){
            result.text = String(Double(result.text!)! * -1)
            print ("neg")}
        mathSign = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

