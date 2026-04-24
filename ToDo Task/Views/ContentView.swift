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
				ForEach(profiles.taskGroups) {group in
                    NavigationLink(value: group) {
                        Label(group.title, systemImage: group.symbolName)
                    }
                }
            }
            .navigationTitle(profiles.name + " To do")
            .listStyle(.sidebar)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "chevron.left")
							.font(.system(size: 16, weight: .bold))
							.foregroundColor(.purple)
							.padding(8)
							.background(Circle().fill(Color.purple.opacity(0.1)))
					}
				}
				
				ToolbarItem(placement: .primaryAction) {
					Button {
						isShowingAddGroup = true
					} label: {
						Image(systemName: "plus")
					}
				}
			}
        } detail : {
            if let group = selectedGroup {
				if let index = profiles.taskGroups.firstIndex(where: {$0.id == group.id}) {
					TaskGroupDetailView(groups: $profiles.taskGroups[index])
                }
            } else {
                ContentUnavailableView("Select a Group", systemImage: "sidebar.left")
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
