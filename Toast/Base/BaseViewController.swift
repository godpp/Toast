//
//  BaseViewController.swift
//  Toast
//
//  Created by ParkSungJoon on 06/07/2019.
//  Copyright © 2019 DDD. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindStyle()
        bindData()
    }
    
    func bindViewModel() {}
    
    func bindData() {}
    
    func bindStyle() {}
}
