//
//  TableViewCell1.swift
//  TableBuilder_Example
//
//  Created by chenbo on 2022/8/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var name: String = "haha" {
        didSet {
            titleLabel.text = name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
