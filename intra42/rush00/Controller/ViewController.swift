//
//  ViewController.swift
//  rush00
//
//  Created by Mishchenko YULIIA on 10/6/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit
import AuthenticationServices

var global_token = GlobalToken(token: "")

class ViewController: UIViewController {
    
    var  getRequest: APIController?
    let UID = "75d5fb7846069478ceb87bfe3f6067fdbbccbcf27ba0fa4e177827d1d6827420"
    let SECRED = "a2f7d9c0ae0836ae12e0881b9662e231598b8ac77a7c92872ccfe8bde298ab40"
    let siteUrl = "myuliia://poraspat"
    var token : String!
    var auth: ASWebAuthenticationSession?
    
    @IBOutlet weak var userName: UITextField!
    @IBAction func connectButton(_ sender: Any) {
        connectLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        postRequestToken()
    }
 

    @IBAction func connectBtn(_ sender: UIButton) {
        if (userInformat != nil) {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "Second") as? ViewController2 else { return }
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "TOKEN is missing or username is invalid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectLogin() {
        if userName.text == "" || self.token == nil {
            print ("Error")
            return
        }
        else {
            self.getRequest = APIController(token: self.token, delegate: self)
            self.getRequest?.getInfoUser(userName: userName.text!)
        }
    }

    func postRequestToken() {
        auth = ASWebAuthenticationSession(url: URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=\(UID)&redirect_uri=\(siteUrl)&response_type=code")!, callbackURLScheme: "myuliia://poraspat")
        { (data, error) in
            if data != nil
            {
                let session = URLSession.shared
                let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
                let request = NSMutableURLRequest(url: url! as URL)
                request.httpBody = "grant_type=authorization_code&client_id=\(self.UID)&client_secret=\(self.SECRED)&\((data?.query!)!)&redirect_uri=\(self.siteUrl)".data(using: String.Encoding.utf8)
                request.httpMethod = "POST"
                session.dataTask(with: request as URLRequest)
                { (data, res, err) in
                    if err != nil
                    {
                        print("Error")
                        return
                    }
                    do
                    {
                        if let dict: NSDictionary = try JSONSerialization.jsonObject(with: data!) as? NSDictionary {
                            print(dict)
                            self.token = dict["access_token"] as? String
                            global_token.token = self.token
                        }
                        else
                        {
                            print("error")
                        }
                    }
                    catch
                    {
                        print("Error 2")
                    }
                    }.resume()
            }
        }
        auth?.start()
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        connectLogin()
        return true
    }
}
