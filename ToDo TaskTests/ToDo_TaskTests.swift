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

    //MARK: New functionality to add a Due Date to my tasks
    @Test("Verify that the TaskItem can store and retrieve a due date")
    func testTaskItemDueDate() {
        // AAA: Arrange, Act and Assert
        // Given, When, Then

        let testDate = Date(timeIntervalSince1970: 1735689600)
        let task = TaskItem(title: "Create Test due Date", dueDate: testDate)

        #expect(task.dueDate == testDate)
    }

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

    // TDD Step 1 (Red): write this test first — it fails because priority doesn't exist yet
    // TDD Step 2 (Green): add `var priority: Priority` to TaskItem and it passes
    // TDD Step 3 (Refactor): default to .medium so existing tasks are not broken
    @Test func taskItemHasDefaultPriority() {
        let task = TaskItem(title: "Test Task")
        #expect(task.priority == .medium)
    }

    // Equivalent to the exercise's testTaskHasPriority — mutating priority after creation
    @Test func taskItemCanChangePriorityAfterCreation() {
        var task = TaskItem(title: "Complete Homework")
        task.priority = .high
        #expect(task.priority == .high)
    }

    @Test func taskItemCanSetPriorityAtInit() {
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

    // MARK: - Priority Display Tests

    @Test func priorityHasCorrectLabels() {
        #expect(Priority.high.label == "High")
        #expect(Priority.medium.label == "Medium")
        #expect(Priority.low.label == "Low")
    }

    // MARK: - TaskGroup Sort Tests

    // TDD Step 1 (Red): write this before implementing sortByPriority()
    // TDD Step 2 (Green): add sortByPriority(ascending:) to TaskGroup
    @Test func taskGroupSortsHighToLow() {
        var group = TaskGroup(title: "Test", symbolName: "star.fill", tasks: [
            TaskItem(title: "Low task", priority: .low),
            TaskItem(title: "High task", priority: .high),
            TaskItem(title: "Medium task", priority: .medium)
        ])
        group.sortByPriority(ascending: true)
        #expect(group.tasks[0].priority == .high)
        #expect(group.tasks[1].priority == .medium)
        #expect(group.tasks[2].priority == .low)
    }

    @Test func taskGroupSortsLowToHigh() {
        var group = TaskGroup(title: "Test", symbolName: "star.fill", tasks: [
            TaskItem(title: "Low task", priority: .low),
            TaskItem(title: "High task", priority: .high),
            TaskItem(title: "Medium task", priority: .medium)
        ])
        group.sortByPriority(ascending: false)
        #expect(group.tasks[0].priority == .low)
        #expect(group.tasks[1].priority == .medium)
        #expect(group.tasks[2].priority == .high)
    }

    @Test func sortingEmptyGroupDoesNotCrash() {
        var group = TaskGroup(title: "Empty", symbolName: "star.fill", tasks: [])
        group.sortByPriority(ascending: true)
        #expect(group.tasks.isEmpty)
    }
}
