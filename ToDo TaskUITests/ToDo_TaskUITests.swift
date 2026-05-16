//
//  ToDo_TaskUITests.swift
//  ToDo TaskUITests
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import XCTest

final class ToDo_TaskUITests: XCTestCase {

	let app = XCUIApplication()

	override func setUpWithError() throws {
		continueAfterFailure = false
		// Default to English so we don't have to set it in every test
		app.launchArguments = ["-AppleLanguages", "(en)"]
	}

	// MARK: - Launch Language Tests

	@MainActor
	func testLaunchEnglish() {
		app.launch()

		// Verify the welcome subtitle is visible on the dashboard
		let header = app.staticTexts["welcomeSubtitle"]
		XCTAssertTrue(header.exists, "Welcome subtitle should be visible when launching in English")
	}

	@MainActor
	func testLaunchSpanish() {
		app.launchArguments = ["-AppleLanguages", "(es-419)"]
		app.launch()

		// Verify the dashboard still loads correctly in Spanish
		let header = app.staticTexts["welcomeSubtitle"]
		XCTAssertTrue(header.exists, "Welcome subtitle should be visible when launching in Spanish")
	}

	// MARK: - Dashboard Tests

	@MainActor
	func testDashboardProfileCardsExist() {
		app.launch()

		let professorCard = app.buttons["profileCard_Professor"]
		let studentCard = app.buttons["profileCard_Student"]

		XCTAssertTrue(professorCard.exists, "Professor profile card should exist")
		XCTAssertTrue(studentCard.exists, "Student profile card should exist")
	}

	@MainActor
	func testNavigateToProfileTasks() {
		app.launch()

		let professorCard = app.buttons["profileCard_Professor"]
		XCTAssertTrue(professorCard.exists, "Professor card should exist on the dashboard")
		professorCard.tap()

		// The add group button in the toolbar confirms we are inside the profile task view
		let addButton = app.buttons["addGroupButton"]
		XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add group button should appear after navigating into a profile")
	}

	// MARK: - Add Group Tests

	@MainActor
	func testAddGroupButtonExists() {
		app.launch()

		let professorCard = app.buttons["profileCard_Professor"]
		professorCard.tap()

		let addButton = app.buttons["addGroupButton"]
		XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add group button should exist in the toolbar")
	}

	@MainActor
	func testAddGroupFlow() {
		app.launch()

		let professorCard = app.buttons["profileCard_Professor"]
		professorCard.tap()

		// Open the new group form
		let addButton = app.buttons["addGroupButton"]
		XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add group button should exist")
		addButton.tap()

		// Verify the sheet opened by checking its navigation bar title
		let sheetNavBar = app.navigationBars["New Group"]
		XCTAssertTrue(sheetNavBar.waitForExistence(timeout: 5), "New Group sheet should appear after tapping add")

		// Type a group name
		let nameField = app.textFields["groupNameTextField"]
		XCTAssertTrue(nameField.waitForExistence(timeout: 3), "Group name text field should exist")
		nameField.tap()
		nameField.typeText("My Test Group")

		// Select the star icon
		let iconOption = app.images["iconOption_star.fill"].firstMatch
		if iconOption.waitForExistence(timeout: 2) {
			iconOption.tap()
		}

		// Save the new group
		let saveButton = app.buttons["saveButton"]
		XCTAssertTrue(saveButton.waitForExistence(timeout: 2), "Save button should exist")
		saveButton.tap()

		// Verify the new group appears in the sidebar
		let newGroup = app.buttons["sidebarGroup_My Test Group"].firstMatch
		XCTAssertTrue(newGroup.waitForExistence(timeout: 5), "Newly created group should appear in the sidebar")
	}

	// MARK: - Add Task Flow

	@MainActor
	func testAddingTask() {
		app.launch()

		// Dashboard → Professor profile
		app.buttons["profileCard_Professor"].tap()

		// Open an existing sample group ("Groceries") to reach the task list
		let groceries = app.buttons["sidebarGroup_Groceries"].firstMatch
		XCTAssertTrue(groceries.waitForExistence(timeout: 5), "Groceries group should be visible in the sidebar")
		groceries.tap()

		// Tap the toolbar "+" to append a new empty task
		let addTaskButton = app.buttons["addTaskButton"]
		XCTAssertTrue(addTaskButton.waitForExistence(timeout: 5), "Add task button should exist in the toolbar")

		let taskFieldsQuery = app.textFields.matching(NSPredicate(format: "identifier BEGINSWITH 'taskTextField_'"))
		let initialCount = taskFieldsQuery.count
		addTaskButton.tap()

		// Wait for the new row to appear (count increases by one)
		let newRowAppeared = expectation(for: NSPredicate(format: "count == %d", initialCount + 1),
		                                evaluatedWith: taskFieldsQuery)
		wait(for: [newRowAppeared], timeout: 5)

		// Type into the newest field (last one in the list)
		let newField = taskFieldsQuery.element(boundBy: initialCount)
		newField.tap()
		newField.typeText("Complete Assignment")

		// The field's value reflects what we typed
		XCTAssertEqual(newField.value as? String, "Complete Assignment")
	}

	// MARK: - Back Navigation Test

	@MainActor
	func testBackButtonReturnsToProfiles() {
		app.launch()

		let professorCard = app.buttons["profileCard_Professor"]
		professorCard.tap()

		// Tap the custom back button to return to the dashboard
		let backButton = app.buttons["backButton"]
		XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Back button should exist in the toolbar")
		backButton.tap()

		// Verify the dashboard welcome title is visible again
		let welcomeTitle = app.staticTexts["welcomeTitle"]
		XCTAssertTrue(welcomeTitle.waitForExistence(timeout: 5), "Should return to dashboard with welcome title visible")
	}
}
