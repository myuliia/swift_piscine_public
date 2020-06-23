//
//  ViewController2.swift
//  rush00
//
//  Created by Mishchenko YULIIA on 10/6/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit

class tableCursus : UITableViewCell {
    @IBOutlet weak var cursusLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
}

class ViewController2: UIViewController {
    
    var token : String!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBAction func logoutBtn(_ sender: UIBarButtonItem) {
        
        userInformat = nil
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstStoryboard") as? ViewController else { return }
        //self.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = userInformat?.first_name
        surnameLabel.text = userInformat?.last_name
        loginLabel.text = userInformat?.login
        let url = URL(string: userInformat!.photo)
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
    }
    

}
extension ViewController2: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userInformat?.nameCursus.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CursusCell", for: indexPath) as! tableCursus
        cell.cursusLabel.text = userInformat?.nameCursus[indexPath.row]
        cell.levelLabel.text = String(format: "%.2f", (userInformat?.levelCursus[indexPath.row])!)
        return cell
    }
    
    
}

