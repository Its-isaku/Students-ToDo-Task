//
//  LocaleTheme.swift
//  ToDo Task
//
//  Provides locale-specific theming for cultural customization.
//  Adapts colors and visual styles based on the current device locale.
//

import SwiftUI

struct LocaleTheme {

	/// Returns true if the current locale is Arabic
	static var isArabic: Bool {
		Locale.current.language.languageCode?.identifier == "ar"
	}

	// MARK: - Core Colors

	/// Primary accent color
	static var accentColor: Color {
		isArabic ? Color("ArabicGold") : Color(red: 0.35, green: 0.45, blue: 0.98) // Soft indigo
	}

	/// Secondary accent for highlights and details
	static var secondaryAccent: Color {
		isArabic ? Color("ArabicGold").opacity(0.7) : Color(red: 1.0, green: 0.55, blue: 0.38) // Warm coral
	}

	/// Success/completion color
	static var successColor: Color {
		Color(red: 0.30, green: 0.78, blue: 0.55) // Fresh green
	}

	/// Background color
	static var backgroundColor: Color {
		isArabic ? Color("ArabicSand") : Color(.systemGroupedBackground)
	}

	/// Secondary background for cards
	static var secondaryBackground: Color {
		isArabic ? Color("ArabicSand").opacity(0.5) : Color(.secondarySystemBackground)
	}

	// MARK: - Category Colors (for sidebar icons and cards)

	static let categoryColors: [Color] = [
		Color(red: 0.35, green: 0.45, blue: 0.98), // Indigo
		Color(red: 1.0, green: 0.55, blue: 0.38),  // Coral
		Color(red: 0.30, green: 0.78, blue: 0.55),  // Green
		Color(red: 0.95, green: 0.65, blue: 0.20),  // Amber
		Color(red: 0.75, green: 0.38, blue: 0.95),  // Purple
		Color(red: 0.25, green: 0.75, blue: 0.85),  // Teal
		Color(red: 0.95, green: 0.40, blue: 0.50),  // Rose
		Color(red: 0.55, green: 0.65, blue: 0.30),  // Olive
	]

	/// Get a consistent color for an index (cycles through palette)
	static func colorFor(index: Int) -> Color {
		categoryColors[index % categoryColors.count]
	}

	// MARK: - Gradients

	/// Primary gradient for headers and prominent elements
	static var primaryGradient: LinearGradient {
		LinearGradient(
			colors: [
				Color(red: 0.35, green: 0.45, blue: 0.98),
				Color(red: 0.55, green: 0.40, blue: 0.95)
			],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
	}

	/// Warm gradient for profile cards
	static var warmGradient: LinearGradient {
		LinearGradient(
			colors: [
				Color(red: 1.0, green: 0.55, blue: 0.38),
				Color(red: 0.95, green: 0.40, blue: 0.50)
			],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
	}

	/// Progress ring gradient
	static var progressGradient: AngularGradient {
		AngularGradient(
			colors: [
				Color(red: 0.35, green: 0.45, blue: 0.98),
				Color(red: 0.30, green: 0.78, blue: 0.55),
				Color(red: 0.35, green: 0.45, blue: 0.98)
			],
			center: .center
		)
	}
}

// MARK: - Arabic Geometric Pattern Background
/// A decorative geometric pattern inspired by traditional Arabic/Islamic design.
/// Used as background overlay when the locale is Arabic.
struct ArabicPatternBackground: View {
	var body: some View {
		GeometryReader { geo in
			let tileSize: CGFloat = 50
			let cols = Int(geo.size.width / tileSize) + 1
			let rows = Int(geo.size.height / tileSize) + 1

			Canvas { context, _ in
				for row in 0..<rows {
					for col in 0..<cols {
						let x = CGFloat(col) * tileSize + tileSize / 2
						let y = CGFloat(row) * tileSize + tileSize / 2
						let radius: CGFloat = tileSize * 0.35

						// Draw an 8-pointed star (common in Islamic geometric art)
						let starPath = eightPointedStar(center: CGPoint(x: x, y: y), radius: radius)
						context.stroke(starPath, with: .color(Color("ArabicGold").opacity(0.12)), lineWidth: 0.8)
					}
				}
			}
		}
		.allowsHitTesting(false)
	}

	/// Creates an 8-pointed star path at the given center and radius
	private func eightPointedStar(center: CGPoint, radius: CGFloat) -> Path {
		let innerRadius = radius * 0.5
		let points = 8

		return Path { path in
			for i in 0..<(points * 2) {
				let angle = (Double(i) * .pi / Double(points)) - .pi / 2
				let r = i.isMultiple(of: 2) ? radius : innerRadius
				let x = center.x + CGFloat(cos(angle)) * r
				let y = center.y + CGFloat(sin(angle)) * r

				if i == 0 {
					path.move(to: CGPoint(x: x, y: y))
				} else {
					path.addLine(to: CGPoint(x: x, y: y))
				}
			}
			path.closeSubpath()
		}
	}
}
