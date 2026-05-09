//
//  ToDo_TaskTests.swift
//  ToDo TaskTests
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import Foundation
import Testing
@testable import ToDo_Task

struct ToDo_TaskTests {

    // MARK: - Priority Enum Tests

    @Test func priorityHasThreeCases() {
        let all = Priority.allCases
        #expect(all.count == 3)
        #expect(all.contains(.high))
        #expect(all.contains(.medium))
        #expect(all.contains(.low))
    }

    @Test func prioritySortOrder() {
        #expect(Priority.high.rawValue < Priority.medium.rawValue)
        #expect(Priority.medium.rawValue < Priority.low.rawValue)
    }

    @Test func priorityIsCodable() throws {
        let encoded = try JSONEncoder().encode(Priority.high)
        let decoded = try JSONDecoder().decode(Priority.self, from: encoded)
        #expect(decoded == .high)
    }

    // MARK: - TaskItem Priority Tests

    @Test func taskItemHasDefaultPriority() {
        let task = TaskItem(title: "Test Task")
        #expect(task.priority == .medium)
    }

    @Test func taskItemCanSetPriority() {
        let task = TaskItem(title: "Urgent", priority: .high)
        #expect(task.priority == .high)
    }

    @Test func taskItemWithPriorityIsCodable() throws {
        let original = TaskItem(title: "Test", priority: .high)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TaskItem.self, from: data)
        #expect(decoded.title == original.title)
        #expect(decoded.priority == .high)
    }
}
