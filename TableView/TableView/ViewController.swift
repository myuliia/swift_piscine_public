//
//  ViewController.swift
//  TableView
//
//  Created by Mishchenko YULIIA on 10/2/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit

var arrName = ["Vinyavskaya Polina Olegovna", "Kennedy Laura Marry", "Green John Maxwell"]
var arrDate = ["27 May 2019 04:20:00", "30 Nov 2099 23:42:01", "23 Dec 2020 07:34:10"]
var arrReason = ["Overdose from Alpha-methylphenylethylamine", "Autoerotic fatality", "Hit with a blunt object"]

class authorCell: UITableViewCell {
    
    @IBOutlet weak var nameOfPerson: UILabel!
    @IBOutlet weak var dateDeath: UILabel!
    @IBOutlet weak var reasonDeath: UILabel!
}

class ViewController: UIViewController {

    let identifier = "myCell"
//    var array = ["05/27/2019", "Vinyavskaya Polina Olegovna", "overdose from Alpha-methylphenylethylamine", " ", "30.07.1999", "Kennedy Laura Marry\n Autoerotic fatality", " ", "11/23/2018","Green John Maxwell", "hit with a blunt object"]
  
    
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! authorCell
        
      
        let str1 = arrName[indexPath.row]
        let str2 = arrDate[indexPath.row]
        let str3 = arrReason[indexPath.row]
        cell.nameOfPerson?.text = str1
        cell.dateDeath?.text = str2
        cell.reasonDeath?.text = str3
        cell.nameOfPerson?.numberOfLines = 0
        cell.dateDeath?.numberOfLines = 0
        cell.reasonDeath?.numberOfLines = 0
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200.0
//    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//    }

}
