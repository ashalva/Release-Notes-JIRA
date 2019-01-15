//
//  NSViewController+Extensions.swift
//  JIRA
//
//  Created by Shalva Avanashvili on 31/12/2018.
//  Copyright © 2018 ashalva. All rights reserved.
//

import Cocoa

extension NSViewController {
    @discardableResult
    func showAlert(message: String, description: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = description
        alert.alertStyle = .critical
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
}
