//
//  APIControllerClass.swift
//  rush00
//
//  Created by Mishchenko YULIIA on 10/6/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import Foundation
import UIKit


class APIController {
    let token: String
    let delegate: UIViewController
    let siteUrl = "https://api.intra.42.fr/"
    
    init(token: String, delegate: UIViewController) {
        self.token = token
        self.delegate = delegate
    }
    
    func getInfoUser(userName : String) {
        let url = URL(string: siteUrl + "v2/users/\(userName)/")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        print("TOKEN:     ", self.token)
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard error == nil && data != nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                var nameCursus : [String] = []
                var levelCursus : [Double] = []
                let dicJson = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if (dicJson["first_name"] as? String) != nil {
                    print("first name", dicJson["first_name"]!)
                    print("last name", dicJson["last_name"]!)
                    print("login", dicJson["login"]!)
                    print("photo", dicJson["image_url"]!)
                    let firstName = dicJson["first_name"]
                    let lastName = dicJson["last_name"]
                    let login = dicJson["login"]
                    let photo = dicJson["image_url"]
                    let dicCurses : [NSDictionary] = (dicJson["cursus_users"] as? [NSDictionary])!
                    for key in dicCurses {
                        let skills : [NSDictionary] = (key["skills"] as? [NSDictionary])!
                        for sk in skills {
                            print(sk["level"]!)
                            print(sk["name"]!)
                            nameCursus.append(sk["name"] as! String)
                            levelCursus.append(sk["level"] as! Double)
                        }
                    }
                    userInformat = (UserInformation(last_name: lastName as! String, first_name: firstName as! String, login: login as! String, photo: photo as! String, nameCursus: nameCursus, levelCursus: levelCursus))
                } else {
                    print("Error - invalid user")
//                    let alert = UIAlertController(title: "Error", message: "TOKEN is missing or username is invalid", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                    self.delegate.present(alert, animated: true, completion: nil)
                }
            } catch let err {
                print(err)
                return
            }
        }
        task.resume ()
    }
    
}


class APIControllerEvent {
    var delegateEvent : APIEventInformation?
    let siteUrl = "https://api.intra.42.fr/"
    let token: String
    let delegate: ViewController3
    
    init(token: String, delegate: ViewController3) {
        self.token = token
        self.delegate = delegate
    }

    func getInfoEvent(kind : String) {
        let url = URL(string: siteUrl + "v2/events?filter[kind]=\(kind)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard error == nil && data != nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                let dicJson: NSArray = (try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)!
                let dictionar : [NSDictionary] = (dicJson as? [NSDictionary])!
                eventInformation = []
                for key in dictionar {
                    print(key)
                    print("Name: ", key["name"]!)
                    print("Description: ", key["description"]!)
                    print("Max subscribers: ", key["max_people"]!)
                    print("Actual number of subscribers: ", key["nbr_subscribers"]!)
                    print("Location: ",  key["location"]!)
                    print("Kind: ", key["kind"]!)
                    //                     print("Duration: ", (key["begin_at"]! -  key["end_at"]!) // duration
                    print("Begin_time: ", key["begin_at"]!)
                    print("End time: ", key["end_at"]!)

                    let evMaxSubscribers: Int
                    let evName = key["name"] as! String
                    let evDescription = key["description"] as! String
                    if (key["max_people"] == nil) {
                        evMaxSubscribers = key["max_people"] as! Int
                    }
                    else{  evMaxSubscribers = 1  } // here huinya
                    let evActNumbSubscribers =  key["nbr_subscribers"] as! Int
                    let evLocation =  key["location"] as! String
                    let evKind = key["kind"] as! String
                    let evDuration = key["begin_at"] as! String
                    let evBeginTime = key["begin_at"] as! String
                    let evEndTime = key["end_at"] as! String


                    eventInformation.append(EventInformation(evName: evName, evDescription: evDescription, evMaxSubscribers: evMaxSubscribers, evActNumbSubscribers: evActNumbSubscribers, evLocation: evLocation, evKind: evKind, evDuration: evDuration, evBeginTime: evBeginTime, evEndTime: evEndTime))
                }
                DispatchQueue.main.async {
                    self.delegateEvent?.receiveEventInfo(inf: eventInformation)
                    self.delegate.viewTableEvent.reloadData()
                }
            }
            catch let err {
                print(err)
                return
            }
        }
        task.resume()
    }

}
