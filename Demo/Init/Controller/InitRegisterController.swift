//
//  InitRegisterController.swift
//  Demo
//
//  Created by Jiwon Nam on 3/10/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class InitRegisterController: UIViewController {
    var registerView: RegisterView { return view as! RegisterView }

    // MARK: UIViewController Override Functions
    override func loadView() { view = RegisterView() }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerView.frame = view.frame 
    }
}
