//
//  ViewController3.swift
//  rush00
//
//  Created by Mishchenko YULIIA on 10/6/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit

class tableEvents : UITableViewCell {
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventdescription: UILabel!
    @IBOutlet weak var eventMaxSub: UILabel!
    @IBOutlet weak var eventActNumb: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventKind: UILabel!
    @IBOutlet weak var eventDuration: UILabel!
    @IBOutlet weak var eventBeginTime: UILabel!
    @IBOutlet weak var eventEndTime: UILabel!
    
}

class ViewController3: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var  getRequestEv: APIControllerEvent?
     var token : String!
    var last: String = "pedago"
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    @IBOutlet weak var viewTableEvent: UITableView!
    @IBAction func doneAction(_ sender: Any) {
        print("done action")
        print(last)
        getRequestEv = APIControllerEvent(token: global_token.token, delegate: self)
        getRequestEv?.getInfoEvent(kind: last)
    }
    
    let pickerData = ["pedago", "rush", "piscine", "partnership", "meet", "conference", "meet_up", "event", "association", "speed_working", "hackathon", "workshop", "challenge", "other", "extern"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        last = pickerData[row]
    }

    @IBOutlet weak var kindPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
}

extension ViewController3: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("countt ", eventInformation.count)
        return eventInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! tableEvents
        
        cell.eventName.text = "Name: " + eventInformation[indexPath.row].evName
        cell.eventdescription.text = "Description: " + eventInformation[indexPath.row].evDescription
        cell.eventMaxSub.text = "Max Subscribers: " + String(eventInformation[indexPath.row].evMaxSubscribers)
        cell.eventActNumb.text = "Actual Subscribers: " + String( eventInformation[indexPath.row].evActNumbSubscribers)
        cell.eventLocation.text = "Location: " + eventInformation[indexPath.row].evLocation
        cell.eventKind.text = "Event kind : " + eventInformation[indexPath.row].evKind
        cell.eventDuration.text = "Event duration: " + eventInformation[indexPath.row].evDuration
        cell.eventBeginTime.text = "Start: " + eventInformation[indexPath.row].evBeginTime
        cell.eventEndTime.text = "End: " + eventInformation[indexPath.row].evEndTime
        return cell
    }
    

}
