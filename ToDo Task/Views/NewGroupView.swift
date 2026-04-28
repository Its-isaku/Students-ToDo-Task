//
//  NewGroupView.swift
//  ToDo Task
//
//  Created by Isai Magdaleno Almeraz Landeros on 13/04/26.
//

import SwiftUI

struct NewGroupView: View {

	// MARK: - Variables
	@Environment(\.dismiss) var dismiss
	@State private var groupName: String = ""
	@State private var selectedIcon: String = "list.bullet"

	let icons = ["house.fill", "star.fill", "list.bullet", "book.fill", "cart.fill", "heart.fill"]
	var onSave: (TaskGroup) -> ()

	// MARK: - View
	var body: some View {

		NavigationStack {
			Form {
				// Section1: Group title
				Section {
					TextField("e.g. Work, Groceries, Fitness...", text: $groupName)
						.font(.system(.body, design: .rounded))
						.accessibilityIdentifier("groupNameTextField")
				} header: {
					Label("Group Name", systemImage: "character.cursor.ibeam")
						.font(.system(.caption, design: .rounded))
						.fontWeight(.semibold)
						.foregroundStyle(LocaleTheme.accentColor)
						.accessibilityIdentifier("groupNameSectionHeader")
				}

				// Section2: symbol Icon
				Section {
					LazyVGrid(columns: [GridItem(.adaptive(minimum: 56))], spacing: 14) {
						ForEach(Array(icons.enumerated()), id: \.element) { index, icon in
							let color = LocaleTheme.colorFor(index: index)
							Image(systemName: icon)
								.font(.title2)
								.foregroundStyle(selectedIcon == icon ? .white : color)
								.frame(width: 52, height: 52)
								.background(
									RoundedRectangle(cornerRadius: 14, style: .continuous)
										.fill(selectedIcon == icon ? color : color.opacity(0.12))
								)
								.scaleEffect(selectedIcon == icon ? 1.08 : 1.0)
								.contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
								.animation(.easeInOut(duration: 0.15), value: selectedIcon)
								.onTapGesture {
									selectedIcon = icon
								}
								.accessibilityIdentifier("iconOption_\(icon)")
						}
					}
					.padding(.vertical, 8)
					.accessibilityIdentifier("iconGrid")
				} header: {
					Label("Icon", systemImage: "square.grid.2x2")
						.font(.system(.caption, design: .rounded))
						.fontWeight(.semibold)
						.foregroundStyle(LocaleTheme.secondaryAccent)
						.accessibilityIdentifier("iconSectionHeader")
				}
			}
			.navigationTitle(Text("New Group"))
			.toolbar{
				ToolbarItem(placement: .cancellationAction){
					Button("Cancel") { dismiss() }
						.foregroundStyle(.secondary)
						.accessibilityIdentifier("cancelButton")
				}

				ToolbarItem(placement: .confirmationAction){
					Button {
						let newGroup = TaskGroup(title: groupName, symbolName: selectedIcon, tasks: [])
						onSave(newGroup)
						dismiss()
					} label: {
						Text("Save")
							.font(.system(.body, design: .rounded))
							.fontWeight(.bold)
							.foregroundStyle(groupName.isEmpty ? .secondary : LocaleTheme.accentColor)
					}
					.disabled(groupName.isEmpty)
					.accessibilityIdentifier("saveButton")
				}
			}
			.accessibilityIdentifier("newGroupForm")
		}
    }
}
