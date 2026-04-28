//
//  ContentView.swift
//  ToDo Task
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import SwiftUI

struct ContentView: View {
	@State private var taskGroups: [TaskGroup] = []
    @State private var selectedGroup: TaskGroup? // selected group
    @State private var columnVisibility: NavigationSplitViewVisibility = .all // navigation side panel
	@State private var isShowingAddGroup: Bool = false
	@Environment(\.scenePhase) private var scenePhase
	let saveKey = "taskGroupsData"

	@Environment(\.dismiss) private var dismiss
	@Binding var profiles: Profile

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // SIDEBAR
            List(selection: $selectedGroup) {
				ForEach(Array(profiles.taskGroups.enumerated()), id: \.element.id) { index, group in
                    NavigationLink(value: group) {
						HStack(spacing: 12) {
							Image(systemName: group.symbolName)
								.font(.system(size: 14, weight: .semibold))
								.foregroundStyle(.white)
								.frame(width: 32, height: 32)
								.background(
									RoundedRectangle(cornerRadius: 8, style: .continuous)
										.fill(LocaleTheme.colorFor(index: index))
								)
								.accessibilityIdentifier("sidebarGroupIcon_\(group.title)")

							VStack(alignment: .leading, spacing: 2) {
								Text(group.title)
									.font(.system(.body, design: .rounded))
									.fontWeight(.medium)
									.accessibilityIdentifier("sidebarGroupTitle_\(group.title)")
								Text("\(group.tasks.count) tasks")
									.font(.caption)
									.foregroundStyle(.secondary)
									.accessibilityIdentifier("sidebarGroupCount_\(group.title)")
							}
						}
						.padding(.vertical, 4)
                    }
					.accessibilityIdentifier("sidebarGroup_\(group.title)")
                }
            }
            .navigationTitle(profiles.name + "'s Tasks")
            .listStyle(.sidebar)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "chevron.left")
							.font(.system(size: 14, weight: .semibold))
							.foregroundStyle(LocaleTheme.accentColor)
							.padding(8)
							.background(
								Circle().fill(LocaleTheme.accentColor.opacity(0.12))
							)
					}
					.accessibilityIdentifier("backButton")
				}

				ToolbarItem(placement: .primaryAction) {
					Button {
						isShowingAddGroup = true
					} label: {
						Image(systemName: "plus.circle.fill")
							.font(.title3)
							.foregroundStyle(LocaleTheme.accentColor)
					}
					.accessibilityIdentifier("addGroupButton")
				}
			}
			.accessibilityIdentifier("sidebarList")
        } detail : {
            if let group = selectedGroup {
				if let index = profiles.taskGroups.firstIndex(where: {$0.id == group.id}) {
					TaskGroupDetailView(groups: $profiles.taskGroups[index])
                }
            } else {
				ContentUnavailableView {
					Label("Select a Group", systemImage: "sidebar.left")
						.foregroundStyle(LocaleTheme.accentColor)
				} description: {
					Text("Choose a task group from the sidebar to get started.")
				}
				.accessibilityIdentifier("emptyStateView")
            }
        }

		.navigationBarHidden(true)

		.sheet(isPresented: $isShowingAddGroup) {

			NewGroupView{NewGroup in
				profiles.taskGroups.append(NewGroup)
				selectedGroup = NewGroup
			}
		}
		.onAppear {
			loadData()
		}
		.onChange(of: scenePhase) { oldValue, newValue in
			if newValue == .active {
				print("App is Active")
			} else if newValue == .inactive {
				print("App us Inactive")
			} else if newValue == .background {
				print("Data is baing saved")
				saveData()
			}
		}
		.accessibilityIdentifier("contentSplitView")
    }

	// MARK: - Data Persistance
	func saveData() {
		if let encodedData = try? JSONEncoder().encode(profiles.taskGroups) {
			// Save it in User Defaults
			UserDefaults.standard.set(encodedData, forKey: saveKey)
		}
	}

	func loadData() {
		if let saveData = UserDefaults.standard.data(forKey: saveKey) {
			if let decodedGroups = try? JSONDecoder().decode([TaskGroup].self, from: saveData) {
				profiles.taskGroups = decodedGroups
				return
			}
		}

		// if no data use mock data
		profiles.taskGroups = TaskGroup.sampleData

	}
}
