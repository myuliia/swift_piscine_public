//
//   APITwitterDelegate.swift
//  Tweet
//
//  Created by Mishchenko YULIIA on 10/4/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import Foundation

protocol APITwitterDelegate {
    func receiveTweets(arg: [Tweet])
    func errorCase(error: NSError)
}
