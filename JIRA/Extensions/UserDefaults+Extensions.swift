//
//  UserDefaults+Extensions.swift
//  JIRA
//
//  Created by Shalva Avanashvili on 31/12/2018.
//  Copyright © 2018 ashalva. All rights reserved.
//

import Foundation

enum Settings: String {
    case jiraDomain
}

extension UserDefaults {
    func setJiraDomain(_ domain: String) {
        set(domain, forKey: Settings.jiraDomain.rawValue)
    }
    
    func jiraDomain() -> String {
        return string(forKey: Settings.jiraDomain.rawValue) ?? ""
    }
}
