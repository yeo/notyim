//
//  SessionService.swift
//  noty
//
//  Created by Vinh Nguyen on 5/13/17.
//  Copyright © 2017 Noty. All rights reserved.
//

import Foundation

class SessionService {
    static let sharedInstance = SessionService()
    
    var token: String?
    
    private init() { //This prevents others from using the default '()' initializer for this class.
    
    }
    

    func setToken(token: String) {
        SimpleStorageService.sharedInstance.setKey(key: "token", value: token)
    }
    
    func hasToken() -> Bool {
        token = SimpleStorageService.sharedInstance.getKey(key: "token")
        return token != nil
    }
}
