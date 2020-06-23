//
//  ViewController.swift
//  siri
//
//  Created by Mishchenko YULIIA on 10/10/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO
import MapKit


let RecastToken : String = "ae460347dbc06fe053fc06516dbc027a"
let ForecastToken : String = "5b2afed93e2e8e4efc5d13965f2413d0"



class ViewController: UIViewController {
    var bot : RecastAIClient?
//    var forecastClient :
    let client = DarkSkyClient(apiKey: ForecastToken)
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    
    
    @IBAction func pressButton(_ sender: UIButton) {
        print(textField.text!)
        let text : String = textField.text!
        if textField.text != "" {
            makeRequest(text : text)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bot = RecastAIClient(token : RecastToken, language: "en")
        client.units = .si
    }
    func makeRequest(text : String)
    {
        self.bot?.textRequest(textField.text ?? "Kiev", successHandler: { (response) in
           if let location = response.get(entity: "location")
           {
            self.darkSkyWeather(myLat: location["lat"] as! Double, myLon: location["lng"] as! Double)
            }
        }, failureHandle: { (Error) in
            print("error")
        })
        
    }

    
    func darkSkyWeather(myLat : Double, myLon : Double) {
        
        let myLoc = CLLocationCoordinate2D(latitude: myLat, longitude: myLon)
        client.getForecast(location: myLoc) { result in
            switch result {
            case .success(let currentForecast, let requestMetadata):
                    DispatchQueue.main.async {
                        self.answerLabel.text = "Forecast: " + (currentForecast.daily?.summary)! + "\n\n Daily weather: \(currentForecast.currently!.summary!) \n Dew point: \(currentForecast.currently!.dewPoint!)\n Pressure: \(currentForecast.currently!.pressure!) hPa\n Wind Speed: \(currentForecast.currently!.windSpeed!) m\\s \n Humidity: \(currentForecast.currently!.humidity!) %\n Temperature \(currentForecast.currently!.temperature!)ºC"
                    }
                print(requestMetadata)
                print("Summury ", currentForecast.daily?.summary! as Any)
                print("Cloud Cover", currentForecast.currently?.cloudCover! as Any)
                print("Dew point", currentForecast.currently?.dewPoint! as Any)
                print("Humidity", currentForecast.currently?.humidity! as Any)
                print("Pressure", currentForecast.currently?.pressure! as Any)
                print("windSpeed", currentForecast.currently?.windSpeed! as Any)
                print("summary", currentForecast.currently?.summary! as Any)
                print("ФpparentTemperature", currentForecast.currently?.apparentTemperature! as Any)
            case .failure(let error):
                print(error)
            }
        }
    }


}
