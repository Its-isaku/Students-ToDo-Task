//
//  DashboardView.swift
//  ToDo Task
//
//  Created by Isai Magdaleno Almeraz Landeros on 22/04/26.
//

import SwiftUI

struct DashboardView: View {

	// MARK: - Variables
	@State private var profiles: [Profile] = Profile.sampleProfile
	@State private var path = NavigationPath()

	let columns = [
		GridItem(.flexible(), spacing: 20),
		GridItem(.flexible(), spacing: 20)
	]

	/// Assigns a gradient to each profile card by index
	private let cardGradients: [LinearGradient] = [
		LocaleTheme.primaryGradient,
		LocaleTheme.warmGradient
	]

	// MARK: - Body
	var body: some View {
		NavigationStack(path: $path) {
			ZStack {
				LocaleTheme.backgroundColor
					.ignoresSafeArea()
				if LocaleTheme.isArabic {
					ArabicPatternBackground()
						.ignoresSafeArea()
				}

				ScrollView {
					VStack(spacing: 32) {
						// Header
						VStack(spacing: 8) {
							Image(systemName: "checkmark.seal.fill")
								.font(.system(size: 44))
								.foregroundStyle(LocaleTheme.accentColor)
								.padding(.bottom, 4)
								.accessibilityIdentifier("welcomeIcon")

							Text("Welcome Back")
								.font(.system(.largeTitle, design: .rounded))
								.fontWeight(.bold)
								.accessibilityIdentifier("welcomeTitle")

							Text("Who is logging in today?")
								.font(.system(.body, design: .rounded))
								.foregroundStyle(.secondary)
								.accessibilityIdentifier("welcomeSubtitle")
						}
						.padding(.top, 24)

						// Profile Cards
						LazyVGrid(columns: columns, spacing: 20) {
							ForEach(Array(profiles.enumerated()), id: \.element.id) { index, profile in
								NavigationLink(value: profile) {
									VStack(spacing: 12) {
										Image(profile.profileImage)
											.resizable()
											.scaledToFit()
											.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
											.accessibilityIdentifier("profileImage_\(profile.name)")

										Text(profile.name)
											.font(.system(.headline, design: .rounded))
											.fontWeight(.semibold)
											.foregroundStyle(.primary)
											.accessibilityIdentifier("profileName_\(profile.name)")
									}
									.padding(12)
									.background(
										RoundedRectangle(cornerRadius: 20, style: .continuous)
											.fill(Color(.secondarySystemGroupedBackground))
									)
								}
								.accessibilityIdentifier("profileCard_\(profile.name)")
							}
						}
						.padding(.horizontal, 20)
						.accessibilityIdentifier("profileGrid")

						Spacer(minLength: 40)
					}
				}
				.accessibilityIdentifier("dashboardScrollView")
			}

			.navigationTitle("Profiles")
			.navigationDestination(for: Profile.self) { selectedProfiles in
				if let index = profiles.firstIndex(where: {$0.id == selectedProfiles.id}) {
					ContentView(profiles: $profiles[index])
				}
			}
		}
		.accessibilityIdentifier("dashboardNavigationStack")
    }
}
