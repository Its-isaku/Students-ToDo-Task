//
//  TaskModels.swift
//  ToDo Task
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import Foundation
import SwiftUI

enum Priority: Int, CaseIterable, Codable, Hashable {
    case high = 0
    case medium = 1
    case low = 2

    var label: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }

    var icon: String {
        switch self {
        case .high: return "exclamationmark.3"
        case .medium: return "exclamationmark.2"
        case .low: return "exclamationmark"
        }
    }

    var color: Color {
        switch self {
        case .high: return Color(red: 0.95, green: 0.40, blue: 0.50)
        case .medium: return Color(red: 0.95, green: 0.65, blue: 0.20)
        case .low: return Color(red: 0.30, green: 0.78, blue: 0.55)
        }
    }
}

struct TaskItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var priority: Priority = .medium
}

struct TaskGroup: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var symbolName: String
    var tasks: [TaskItem]

    mutating func sortByPriority(ascending: Bool = true) {
        if ascending {
            tasks.sort { $0.priority.rawValue < $1.priority.rawValue }
        } else {
            tasks.sort { $0.priority.rawValue > $1.priority.rawValue }
        }
    }
}

struct Profile: Identifiable, Hashable, Codable {
	var id = UUID()
	var name: String
	var profileImage: String
	var taskGroups: [TaskGroup]
}

// MOCK DATA
extension TaskGroup {
    static let sampleData: [TaskGroup] = [
        TaskGroup(title: "Groceries", symbolName: "storefront.circle.fill", tasks: [
            TaskItem(title: "Buy Apples"),
            TaskItem(title: "Buy Milk")
        ]),
        
        TaskGroup(title: "Home", symbolName: "house.fill", tasks: [
            TaskItem(title: "Walk the dog", isCompleted: true ),
            TaskItem(title: "Clean the kitchen")
        ])
    ]
}

extension Profile {
	static let sampleProfile: [Profile] = [
		Profile(name: "Professor",profileImage: "professorImg", taskGroups: TaskGroup.sampleData),
		Profile(name: "Student",profileImage: "studentImg", taskGroups: [])
	]
}
