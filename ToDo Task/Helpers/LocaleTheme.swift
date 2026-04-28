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

	/// Accent color: gold for Arabic, cyan for default
	static var accentColor: Color {
		isArabic ? Color("ArabicGold") : .cyan
	}

	/// Background color: warm sand for Arabic, system default for others
	static var backgroundColor: Color {
		isArabic ? Color("ArabicSand") : Color(.systemGroupedBackground)
	}

	/// Secondary background for Arabic theme
	static var secondaryBackground: Color {
		isArabic ? Color("ArabicSand").opacity(0.5) : Color(.secondarySystemBackground)
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
