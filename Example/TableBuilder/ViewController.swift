//
//  ViewController.swift
//  TableBuilder
//
//  Created by chenbo on 08/17/2022.
//  Copyright (c) 2022 chenbo. All rights reserved.
//

import UIKit
import TableBuilder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = ListVC()
        navigationController?.pushViewController(vc, animated: true)
    }

}

