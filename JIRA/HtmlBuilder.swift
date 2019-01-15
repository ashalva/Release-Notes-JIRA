//
//  HtmlBuilder.swift
//  JIRA
//
//  Created by Shalva Avanashvili on 28/12/2018.
//  Copyright © 2018 ashalva. All rights reserved.
//

import Foundation

class HtmlBuilder {
    private var htmlSource: String = ""
    private var domain : String = ""
    
    func append(title: String, content: [String]) -> HtmlBuilder {
        let linkedContent = setLinks(content)
        
        htmlSource += linkedContent.reduce("<strong> \(title): </strong> <br>", { res, substring in
            return res + "<li>" + substring + "</li>"
        })
        htmlSource += "</ul> </br>"
        
        return self
    }
    
    func build() -> String {
        return htmlSource
    }
    
    func setDomain(_ domain: String) -> HtmlBuilder {
        self.domain = domain
        return self
    }
    
    private func setLinks(_ tasks: [String]) -> [String] {
        return tasks.map { (value: String) -> String in
            if let taskCode = value.components(separatedBy: " ").first {
                let link = "<a href='\(domain)/jira/browse/\(taskCode)'>"
                return value.replacingOccurrences(of: taskCode, with: "\(link)\(taskCode)</a>")
            } else {
                return value
            }
        }
    }
}
