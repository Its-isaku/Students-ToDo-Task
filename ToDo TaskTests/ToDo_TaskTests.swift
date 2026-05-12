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

        let testDate = Date(timeIntervalSince1970: 1735689600)
        let task = TaskItem(title: "Create Test due Date", dueDate: testDate)

        #expect(task.dueDate == testDate)
    }

    //MARK: Overdue functionality
    @Test("Task with a past due date is overdue")
    func testTaskWithPastDateIsOverdue() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let task = TaskItem(title: "Pay bill", dueDate: yesterday)

        #expect(task.isOverdue)
    }

    @Test("Task with no due date is never overdue")
    func testTaskWithoutDueDateIsNotOverdue() {
        let task = TaskItem(title: "Someday")

        #expect(!task.isOverdue)
    }

    @Test("Task with a future due date is not overdue")
    func testTaskWithFutureDateIsNotOverdue() {
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: .now)!
        let task = TaskItem(title: "Future", dueDate: nextWeek)

        #expect(!task.isOverdue)
    }

    @Test("A completed task is never overdue, even if the date has passed")
    func testCompletedTaskIsNotOverdue() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        var task = TaskItem(title: "Done", dueDate: yesterday)
        task.isCompleted = true

        #expect(!task.isOverdue)
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
