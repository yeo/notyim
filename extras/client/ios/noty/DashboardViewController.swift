//
//  FirstViewController.swift
//  noty
//
//  Created by Vinh Nguyen on 4/7/17.
//  Copyright © 2017 Noty. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    var session: SessionService!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        session = SessionService.sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if session.hasToken() {
            
        } else {
            self.performSegue(withIdentifier: "login", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

