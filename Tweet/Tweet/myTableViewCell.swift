//
//  myTableViewCell.swift
//  Tweet
//
//  Created by Mishchenko YULIIA on 10/5/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {
//lables
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var discipt: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
