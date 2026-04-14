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
	
	let icons = ["house.fill", "star.fill", "list.bullet"]
	var onSave: (TaskGroup) -> ()
	
	// MARK: - View
	var body: some View {
		
		NavigationStack {
			Form {
				// Section1: Group title
				Section("Group Name") {
					TextField("e.g. Work", text: $groupName)
				}
				
				// Section2: symbol Icon
				Section("Select Icon") {
					LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
						ForEach(icons, id: \.self) { icon in
							Image(systemName: icon)
								.font(.title2)
								.foregroundStyle(selectedIcon == icon ? Color.white : Color.primary)
								.frame(width: 40, height: 40)
								.background(
									RoundedRectangle(cornerRadius: 16, style: .continuous)
										.fill(selectedIcon == icon ? Color.blue : Color.clear)
								)
								.contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
								.onTapGesture {
									selectedIcon = icon
								}
						}
					}
				}
			}
			.navigationTitle(Text("New Group"))
			.toolbar{
				ToolbarItem(placement: .cancellationAction){
					Button("Cancel") { dismiss() }
				}
				
				ToolbarItem(placement: .confirmationAction){
					Button("Save") {
						let newGroup = TaskGroup(title: groupName, symbolName: selectedIcon, tasks: [])
						onSave(newGroup)
						dismiss()
						
					}
				}
			}
		}
    }
}

