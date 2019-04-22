//
//  Analyser.swift
//  JIRA
//
//  Created by Shalva Avanashvili on 01/12/2018.
//  Copyright © 2018 ashalva. All rights reserved.
//

class Analyser {
    enum AnalysisType: String {
        case iOS
        case android = "Android"
        case noFilter
        case other
    }
    
    enum TaskType: String {
        case feature = "Task"
        case improvements = "Improvement"
        case bugs = "Bug"
        case others
    }
    
    let jiraInput: String
    let jiraDomain: String
    var type: AnalysisType = .iOS
    var otherPlatform: String? = nil
    
    init(jiraInput: String, type: AnalysisType = .iOS, otherPlatform: String? = nil, jiraDomain: String) {
        guard !jiraInput.isEmpty else {
            fatalError("Analyser must be constracted with non-empty input")
        }
        
        self.jiraInput = jiraInput
        self.type = type
        self.otherPlatform = otherPlatform
        self.jiraDomain = jiraDomain
    }
    
    init() {
        fatalError("Analyser must be constracted with non-empty input")
    }
    
    var analysis: String {
        let tasks = jiraInput.split(separator: "\n")
        
        var platformTasks = type == .noFilter ? tasks : tasks.filter { $0.contains(filterString(for: type)) }
        
        let features = filter(&platformTasks, with: .feature)
        let improvements = filter(&platformTasks, with: .improvements)
        let bugs = filter(&platformTasks, with: .bugs)
        let others = clean(((platformTasks.filter { !features.contains(String($0)) }).filter { !improvements.contains(String($0)) }).filter { !bugs.contains(String($0)) })
        
        return HtmlBuilder().setDomain(jiraDomain)
            .append(title: "Improvements", content: improvements)
            .append(title: "Bugs", content: bugs)
            .append(title: "Features", content: features)
            .append(title: "Others", content: others)
            .build()
    }
    
    
    private func filterString(for type: AnalysisType) -> String {
        var filterString = ""
        switch type {
        case .android, .iOS:
            filterString = type.rawValue
        case .other:
            filterString = otherPlatform!
        case .noFilter:
            filterString = ""
        }
        
        return filterString
    }
    
    private func filter( _ tasks: inout [Substring], with type: TaskType) -> [String] {
        let filteredTasks = tasks.filter { $0.contains(type.rawValue) }
        
        tasks = tasks.filter { !filteredTasks.contains($0)}
        return clean(filteredTasks)
    }
    
    private func clean(_ tasks: [Substring]) -> [String] {
        return tasks.map { $0.replacingOccurrences(of: "Closed", with: "")
            .replacingOccurrences(of: "Improvement", with: "")
            .replacingOccurrences(of: "Story", with: "")
            .replacingOccurrences(of: "Medium", with: "")
            .replacingOccurrences(of: "Nice to have", with: "")
            .replacingOccurrences(of: "Bug", with: "")
            .replacingOccurrences(of: "Task", with: "")
            .replacingOccurrences(of: "CLOSED", with: "")
            .replacingOccurrences(of: " *    ", with: "    ")
            .replacingOccurrences(of: "→", with: "")
            .replacingOccurrences(of: "\t", with: " ")
            .replacingOccurrences(of: " *", with: "")
        }
    }
}
