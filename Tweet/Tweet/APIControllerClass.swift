//
//  APIControllerClass.swift
//  Tweet
//
//  Created by Mishchenko YULIIA on 10/4/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import Foundation

class APIController {
    var delegate : APITwitterDelegate?
    let token: String
    
   

    init(delegate: APITwitterDelegate?, token: String) {
        self.delegate = delegate
        self.token = token
        
      
    }
    func executeRequest(string: String) {
        var request = URLRequest(url: URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(string)&count=100&lang=en&result_type=recent".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
            request.httpMethod = "GET"
            request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
             (data, response, error) in
            guard error == nil && data != nil else {
                print(error!.localizedDescription)
                return
            }
            do {
            var tweet : [Tweet] = []
               let dicJson = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                 let status : [NSDictionary] = (dicJson["statuses"] as? [NSDictionary])!
                for key in status {
                    let name = key["user"] as! NSDictionary
                    let date = key["created_at"]
                    let text = key["text"]
                    tweet.append(Tweet(name: name.value(forKey: "name")! as! String, text: text! as! String, date: date as! String))
                }
                DispatchQueue.main.async {
                    self.delegate?.receiveTweets(arg: tweet)
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
