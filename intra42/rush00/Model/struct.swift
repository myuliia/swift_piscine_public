//
//  struct.swift
//  rush00
//
//  Created by Mishchenko YULIIA on 10/6/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import Foundation

struct UserInformation {
    var last_name: String
    var first_name: String
    var login: String
    var photo: String
    var nameCursus: [String]
    var levelCursus: [Double]
}

struct EventInformation {
    let evName: String
    let evDescription: String
    let evMaxSubscribers: Int
    let evActNumbSubscribers: Int
    let evLocation: String
    let evKind: String
    let evDuration: String
    let evBeginTime: String
    let evEndTime: String
}

var userInformat : UserInformation?
var eventInformation : [EventInformation] = []

struct GlobalToken {
    var token: String
}
