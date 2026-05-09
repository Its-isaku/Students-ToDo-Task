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
						Button {
							withAnimation(.easeInOut(duration: 0.2)) {
								task.isCompleted.toggle()
							}
						} label: {
							Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
								.font(.system(size: 22))
								.foregroundStyle(
									task.isCompleted ? LocaleTheme.successColor : .gray.opacity(0.35)
								)
								.symbolEffect(.bounce, value: task.isCompleted)
						}
						.buttonStyle(.plain)
						.accessibilityLabel(task.isCompleted ? "Completed" : "Not completed")
						.accessibilityIdentifier("taskCheckmark_\(task.id)")

						TextField("Task Title", text: $task.title)
							.font(.system(.body, design: .rounded))
							.strikethrough(task.isCompleted)
							.foregroundStyle(task.isCompleted ? .secondary : .primary)
							.accessibilityIdentifier("taskTextField_\(task.id)")

						Spacer()

						Menu {
							ForEach(Priority.allCases, id: \.self) { priority in
								Button {
									$task.wrappedValue.priority = priority
								} label: {
									Label(priority.label, systemImage: priority.icon)
								}
							}
						} label: {
							Image(systemName: $task.wrappedValue.priority.icon)
								.font(.system(size: 14))
								.foregroundStyle($task.wrappedValue.priority.color)
								.padding(6)
								.background(
									Circle()
										.fill($task.wrappedValue.priority.color.opacity(0.12))
								)
						}
						.accessibilityIdentifier("taskPriority_\(task.id)")
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
			Menu {
				Button {
					withAnimation { groups.sortByPriority(ascending: true) }
				} label: {
					Label("High to Low", systemImage: "arrow.down")
				}
				Button {
					withAnimation { groups.sortByPriority(ascending: false) }
				} label: {
					Label("Low to High", systemImage: "arrow.up")
				}
			} label: {
				Label("Sort", systemImage: "arrow.up.arrow.down")
					.font(.system(.body, design: .rounded))
			}
			.accessibilityIdentifier("sortByPriorityButton")

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
