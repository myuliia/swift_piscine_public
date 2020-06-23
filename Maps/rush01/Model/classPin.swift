//
//  classPin.swift
//  rush01
//
//  Created by Mishchenko YULIIA on 10/12/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import Foundation

struct Pin {
    var country : String?
    var city : String?
    var longitude : Double
    var latitude : Double
    var street : String?
    var streetNumber : String?
    var color : String?
}

var pin : Pin = Pin(country: "", city: "", longitude: 11, latitude: 11, street: "", streetNumber: "", color: "")
var pin2 : Pin = Pin(country: "", city: "", longitude: 11, latitude: 11, street: "", streetNumber: "", color: "")


var counterFirstBut : Int = 0
var counterSecondBut : Int = 0


var whichPinSelect : Int = 1




var whichRoute : Int = 0 // 0 - auto, 1 - walking, 2 - transit
