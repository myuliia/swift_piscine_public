//
//  delegateStruct.swift
//  rush00
//
//  Created by Mishchenko YULIIA on 10/6/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import Foundation

protocol APIUserInformation {
    func receiveUserInfo(inf: [UserInformation])
}

protocol APIEventInformation {
    func receiveEventInfo(inf: [EventInformation])
}
