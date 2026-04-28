//
//  TaskGroupDetailView.swift
//  ToDo Task
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import SwiftUI


struct TaskGroupDetailView: View {
    @Binding var groups: TaskGroup
	@Environment(\.horizontalSizeClass) var sizeClass


    var body: some View {
		// MARK: -  Size Class
        List {
			Section {
				if sizeClass == .regular {
					GroupStatsView(tasks: groups.tasks)
						.listRowInsets(EdgeInsets())
						.listRowBackground(Color(.systemGroupedBackground))
						.accessibilityIdentifier("groupStatsSection")
				}
			}

			Section {
				ForEach($groups.tasks) { $task in
					HStack(spacing: 14) {
						Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
							.font(.system(size: 22))
							.foregroundStyle(
								task.isCompleted ? LocaleTheme.successColor : .gray.opacity(0.35)
							)
							.symbolEffect(.bounce, value: task.isCompleted)
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.2)) {
									task.isCompleted.toggle()
								}
							}
							.accessibilityIdentifier("taskCheckmark_\(task.id)")

						TextField("Task Title", text: $task.title)
							.font(.system(.body, design: .rounded))
							.strikethrough(task.isCompleted)
							.foregroundStyle(task.isCompleted ? .secondary : .primary)
							.accessibilityIdentifier("taskTextField_\(task.id)")
					}
					.padding(.vertical, 4)
					.accessibilityIdentifier("taskRow_\(task.id)")
				}
				.onDelete { index in
					groups.tasks.remove(atOffsets: index)
				}
			} header: {
				HStack {
					Text("\(groups.tasks.count) tasks")
						.accessibilityIdentifier("taskSectionCount")
					Spacer()
					Text("\(groups.tasks.filter { $0.isCompleted }.count) completed")
						.foregroundStyle(LocaleTheme.successColor)
						.accessibilityIdentifier("taskSectionCompleted")
				}
				.font(.system(.caption, design: .rounded))
				.fontWeight(.medium)
				.accessibilityIdentifier("taskSectionHeader")
			}
        }
        .navigationTitle(groups.title)
        .toolbar {
			Button {
				withAnimation {
					groups.tasks.append(TaskItem(title: ""))
				}
			} label: {
				Label("Add Task", systemImage: "plus.circle.fill")
					.font(.system(.body, design: .rounded))
					.fontWeight(.semibold)
					.foregroundStyle(LocaleTheme.accentColor)
			}
			.accessibilityIdentifier("addTaskButton")
        }
		.accessibilityIdentifier("taskGroupDetailList")
    }
}
