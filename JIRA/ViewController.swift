//
//  ViewController.swift
//  JIRA
//
//  Created by Shalva Avanashvili on 30/11/2018.
//  Copyright © 2018 ashalva. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var customPlatformInput: NSTextField!
    @IBOutlet weak var copiedLabel: NSTextField!
    @IBOutlet weak var customRadioButton: NSButton!
    @IBOutlet weak var iOSRadioButton: NSButton!
    @IBOutlet weak var androidRadioButton: NSButton!
    @IBOutlet weak var noFilterRadioButton: NSButton!
    @IBOutlet var richtextview: NSTextView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var jiraDomainTextField: NSTextField!
    
    var analyser: Analyser?
    
    @IBAction func filterClicked(_ sender: Any) {
        guard !jiraDomainTextField.stringValue.isEmpty, !richtextview.string.isEmpty else {
            showAlert(message: "Input missing", description: "Please enter domain and tasks to filter")
            return
        }
        
        var platform: Analyser.AnalysisType = .iOS
        
        if androidRadioButton.state == .on {
            platform = .android
        } else if iOSRadioButton.state == .on {
            platform = .iOS
        } else if noFilterRadioButton.state == .on{
            platform = .noFilter
        } else {
            platform = .other
        }
        
        analyser = Analyser(jiraInput: richtextview.string,
                            type: platform,
                            otherPlatform: customPlatformInput.stringValue,
                            jiraDomain: jiraDomainTextField.stringValue)
    
        webView.loadHTMLString(analyser!.analysis, baseURL: nil)

        UserDefaults.standard.setJiraDomain(jiraDomainTextField.stringValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jiraDomainTextField.stringValue = UserDefaults.standard.jiraDomain()
    }
    
    @IBAction func iOSRadioButtonClicked(_ sender: Any) {
        androidRadioButton.state = .off
        customRadioButton.state = .off
        noFilterRadioButton.state = .off
        customPlatformInput.resignFirstResponder()
    }
    
    @IBAction func androidRadioButtonClicked(_ sender: Any) {
        iOSRadioButton.state = .off
        customRadioButton.state = .off
        noFilterRadioButton.state = .off
        customPlatformInput.resignFirstResponder()
    }
    
    @IBAction func customRadioButtonClicked(_ sender: Any) {
        iOSRadioButton.state = .off
        androidRadioButton.state = .off
        noFilterRadioButton.state = .off
        customPlatformInput.becomeFirstResponder()
    }
    
    @IBAction func noFilterRadioButtonClicked(_ sender: Any) {
        iOSRadioButton.state = .off
        androidRadioButton.state = .off
        customRadioButton.state = .off
        customPlatformInput.resignFirstResponder()
    }
    
    @IBAction func copyResultClicked(_ sender: Any) {
        if let analyser = analyser {
            let pasteBoard = NSPasteboard.general
            pasteBoard.clearContents()
            pasteBoard.setString(analyser.analysis, forType: .html)
            copiedLabel.stringValue = "Copied"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.copiedLabel.stringValue = ""
            })
        }
    }
}
