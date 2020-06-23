//
//  ViewController.swift
//  Tweet
//
//  Created by Mishchenko YULIIA on 10/4/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit


struct Tweet : CustomStringConvertible{
    let name : String
    let text : String
    let date : String
    public var description : String {
        return ("\(name)\n\(date)\n\(text)")
    }
}

class ViewController: UIViewController, APITwitterDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var tweetTableView: UITableView!
    var tweet: [Tweet] = []
    
    @IBOutlet weak var searchTweet: UISearchBar!
    func receiveTweets(arg: [Tweet]) {
        self.tweet = arg
        tweetTableView.reloadData()
    }
    
    func errorCase(error: NSError) {
        print(error)
    }

    let consKey = "DTkgSW62CHLHSBX1dBF6OlpqP"
    let consSecretKey = "GDpXrjcLIP8Ub3zUm6lP9GeQ6HzZtRPUJvXYPQRsiZd74FzILx"
    var  getRequest: APIController?
    var token : String!
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            tweet = []
            self.getRequest = APIController(delegate: self, token: self.token)
            self.getRequest?.executeRequest(string: searchBar.text!)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTweet.delegate = self
        searchTweet.text = "school 42"
            postRequest()
    }
    func postRequest() {
        let bar = ((consKey + ":" + consSecretKey).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
   
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.twitter.com/oauth2/token")! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + bar, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard error == nil && data != nil else {
                print(error!.localizedDescription)  //relpace with error
                return
            }
            do {
                if let dataa = data {
                    if let dictJSon : NSDictionary = try JSONSerialization.jsonObject(with: dataa) as? NSDictionary {
                        for (key, value) in dictJSon {
                            if key as! String == "access_token" {
                                self.token = value as? String
                            }
                        }
                        self.getRequest = APIController(delegate: self, token: self.token)
                        self.getRequest?.executeRequest(string: "school 42")
                        
                    }
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count \(tweet.count)")
        return tweet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! myTableViewCell
        cell.name.text = tweet[indexPath.row].name
        cell.date.text = tweet[indexPath.row].date
        cell.discipt.text = tweet[indexPath.row].text
        print(cell.name.text!)
        print(cell.date.text!)
        print(cell.discipt.text!)
        return cell
    }
    



}
