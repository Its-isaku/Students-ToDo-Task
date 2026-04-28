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
	
	// MARK: - View
	var body: some View {
		HStack {
			ZStack {
				Circle()
					.stroke(lineWidth: 10)
					.opacity(0.3)
				Circle()
					.trim(from: 0.0, to: CGFloat(progress))
					.stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
					.foregroundColor(LocaleTheme.accentColor)
					.rotationEffect(Angle(degrees: -90))
				Text("\(Int(progress * 100))%")
					.font(.caption)
					.bold()
			}
			.frame(width: 60, height: 60)
			.padding()
			
			VStack(alignment: .leading) {
				Text("Task Progress")
				Text("\(completedCount) / \(tasks.count)")
			}
			Spacer()
		}
		.padding()
		.background(LocaleTheme.secondaryBackground)
    }
}
