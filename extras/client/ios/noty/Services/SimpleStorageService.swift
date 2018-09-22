//
//  SimpleStorageService.swift
//  noty
//
//  Created by Vinh Nguyen on 5/27/17.
//  Copyright © 2017 Noty. All rights reserved.
//

import Foundation


class SimpleStorageService {
    static let sharedInstance = SimpleStorageService()
    
    let defaults: UserDefaults
    
    private init() { //This prevents others from using the default '()' initializer for this class.
        defaults = UserDefaults.standard
    }
    
    func getKey(key: String) -> String? {
        return defaults.object(forKey: key) as? String
    }
    
    func setKey(key: String, value: String) {
        defaults.setValue(value, forKey: key)
    }
}
