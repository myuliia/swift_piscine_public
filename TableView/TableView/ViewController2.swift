//
//  ViewController2.swift
//  TableView
//
//  Created by Mishchenko YULIIA on 10/2/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {


    @IBOutlet weak var addName: UITextView!
    @IBOutlet weak var addDate: UIDatePicker!
    @IBOutlet weak var addDescription: UITextView!
    var timeDate: String?

    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        if (addName.text != "")
        {
            arrName.append(addName.text!)
            arrReason.append(addDescription.text!)
            
            let formating = DateFormatter()
            formating.dateFormat = "d MMM yyyy HH:mm:ss"
            timeDate = formating.string(from: addDate.date)
            arrDate.append(timeDate!)
            print ("Time:", timeDate ?? "Time")
            print ("Name: ", addName.text ?? "Name")
            print ("Description: ", addDescription.text!)
            
            let main = storyboard?.instantiateViewController(withIdentifier: "mainStoryboard") as? UINavigationController
            self.present(main!, animated: true, completion: nil)
            view.endEditing(true)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDate.minimumDate = Date()
        addDate.datePickerMode = .dateAndTime
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
