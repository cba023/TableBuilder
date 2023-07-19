//
//  TableViewCell2.swift
//  TableBuilder_Example
//
//  Created by chenbo on 2022/8/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {
    
    let titleLab = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLab)
        titleLab.text = "Cell2_手写代码类型"
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        titleLab.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 42).isActive = true
        titleLab.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.backgroundColor = .magenta
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
