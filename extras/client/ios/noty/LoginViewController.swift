//
//  LoginViewController.swift
//  noty
//
//  Created by Vinh Nguyen on 5/13/17.
//  Copyright © 2017 Noty. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doLogin(_ sender: Any) {
        SessionService.sharedInstance.setToken(token: "1345")
    }
}
