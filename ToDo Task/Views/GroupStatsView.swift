//
//  GroupStatsView.swift
//  ToDo Task
//
//  Created by Isai Magdaleno Almeraz Landeros on 15/04/26.
//

import SwiftUI

struct GroupStatsView: View {
    // MARK: - Variables
	var tasks: [TaskItem]
	var completedCount: Int {tasks.filter{$0.isCompleted}.count}
	var progress: Double {tasks.isEmpty ? 0 : Double(completedCount) / Double(tasks.count)}

	/// Status text based on completion
	private var statusText: String {
		if tasks.isEmpty { return "No tasks yet" }
		if completedCount == tasks.count { return "All done!" }
		if completedCount == 0 { return "Let's get started" }
		return "\(tasks.count - completedCount) remaining"
	}

	// MARK: - View
	var body: some View {
		HStack(spacing: 20) {
			// Progress Ring
			ZStack {
				Circle()
					.stroke(lineWidth: 7)
					.foregroundStyle(.gray.opacity(0.1))

				Circle()
					.trim(from: 0.0, to: CGFloat(progress))
					.stroke(
						LocaleTheme.accentColor,
						style: StrokeStyle(lineWidth: 7, lineCap: .round)
					)
					.rotationEffect(Angle(degrees: -90))
					.animation(.easeInOut(duration: 0.5), value: progress)

				VStack(spacing: 0) {
					Text("\(Int(progress * 100))")
						.font(.system(.title3, design: .rounded))
						.fontWeight(.bold)
						.foregroundStyle(LocaleTheme.accentColor)
					Text("%")
						.font(.system(.caption2, design: .rounded))
						.fontWeight(.semibold)
						.foregroundStyle(.secondary)
				}
				.accessibilityIdentifier("progressPercentage")
			}
			.frame(width: 68, height: 68)
			.accessibilityIdentifier("progressRing")

			VStack(alignment: .leading, spacing: 6) {
				Text("Progress")
					.font(.system(.headline, design: .rounded))
					.accessibilityIdentifier("progressTitle")

				Text("\(completedCount) of \(tasks.count) completed")
					.font(.system(.subheadline, design: .rounded))
					.foregroundStyle(.secondary)
					.accessibilityIdentifier("progressCount")

				Text(statusText)
					.font(.system(.caption, design: .rounded))
					.fontWeight(.medium)
					.foregroundStyle(
						completedCount == tasks.count && !tasks.isEmpty
							? LocaleTheme.successColor
							: LocaleTheme.secondaryAccent
					)
					.accessibilityIdentifier("progressStatus")
			}
			Spacer()
		}
		.padding(18)
		.background(
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(LocaleTheme.secondaryBackground)
				.shadow(color: LocaleTheme.accentColor.opacity(0.08), radius: 8, x: 0, y: 4)
		)
		.accessibilityIdentifier("groupStatsCard")
    }
}
