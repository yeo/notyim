//
//  MainController.swift
//  noty
//
//  Created by Vinh Nguyen on 5/27/17.
//  Copyright © 2017 Noty. All rights reserved.
//

import Foundation


import UIKit

class MainViewController: UINavigationController {
    
    var session: SessionService!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        session = SessionService.sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if session.hasToken() {
              self.performSegue(withIdentifier: "dashboard", sender: self)
        } else {
            self.performSegue(withIdentifier: "login", sender: self)
        }
    }
}
