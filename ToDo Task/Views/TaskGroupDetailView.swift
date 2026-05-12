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
					VStack(alignment: .leading, spacing: 6) {
						HStack(spacing: 14) {
							Button {
								withAnimation { task.isCompleted.toggle() }
							} label: {
								Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
									.font(.system(size: 22))
									.foregroundStyle(task.isCompleted ? LocaleTheme.successColor : .gray.opacity(0.35))
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
								ForEach(Priority.allCases, id: \.self) { p in
									Button { task.priority = p } label: { Label(p.label, systemImage: p.icon) }
								}
							} label: {
								Image(systemName: task.priority.icon)
									.font(.system(size: 14))
									.foregroundStyle(task.priority.color)
									.padding(6)
									.background(Circle().fill(task.priority.color.opacity(0.12)))
							}
							.accessibilityIdentifier("taskPriority_\(task.id)")
						}

						// Due date chip — tap to edit, long-press to remove
						HStack {
							if let dueDate = task.dueDate {
								let color: Color = task.isCompleted ? .secondary : (task.isOverdue ? .red : LocaleTheme.accentColor)
								Label(dueDate.formatted(.dateTime.month(.abbreviated).day()), systemImage: "calendar")
									.font(.system(.caption2, design: .rounded).weight(.semibold))
									.padding(.horizontal, 9).padding(.vertical, 4)
									.background(Capsule().fill(color.opacity(0.14)))
									.foregroundStyle(color)
									.strikethrough(task.isCompleted)
									.overlay {
										DatePicker("", selection: Binding(get: { task.dueDate ?? .now }, set: { task.dueDate = $0 }), displayedComponents: .date)
											.labelsHidden().blendMode(.destinationOver)
									}
									.contextMenu {
										Button("Remove due date", role: .destructive) { task.dueDate = nil }
									}
									.accessibilityIdentifier("taskDueDateChip_\(task.id)")
							} else {
								Button {
									task.dueDate = Calendar.current.startOfDay(for: .now)
								} label: {
									Label("Add date", systemImage: "calendar.badge.plus")
										.font(.system(.caption2, design: .rounded))
										.foregroundStyle(.secondary.opacity(0.7))
								}
								.buttonStyle(.plain)
								.accessibilityIdentifier("taskDueDateButton_\(task.id)")
							}
							Spacer()
						}
						.padding(.leading, 36)
					}
					.padding(.vertical, 4)
					.accessibilityIdentifier("taskRow_\(task.id)")
				}
				.onDelete { groups.tasks.remove(atOffsets: $0) }
			} header: {
				HStack {
					Text("\(groups.tasks.count) tasks").accessibilityIdentifier("taskSectionCount")
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
				Button { withAnimation { groups.sortByPriority(ascending: true) } } label: { Label("High to Low", systemImage: "arrow.down") }
				Button { withAnimation { groups.sortByPriority(ascending: false) } } label: { Label("Low to High", systemImage: "arrow.up") }
			} label: {
				Label("Sort", systemImage: "arrow.up.arrow.down")
					.font(.system(.body, design: .rounded))
			}
			.accessibilityIdentifier("sortByPriorityButton")

			Button {
				withAnimation { groups.tasks.append(TaskItem(title: "")) }
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
