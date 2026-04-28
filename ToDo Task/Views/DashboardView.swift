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
	
	// MARK: - Body
	var body: some View {
		NavigationStack(path: $path) {
			ZStack {
				// MARK: - Locale-Specific Background (Task 3: Arabic Theme)
				LocaleTheme.backgroundColor
					.ignoresSafeArea()
				if LocaleTheme.isArabic {
					ArabicPatternBackground()
						.ignoresSafeArea()
				}
				ScrollView {
					VStack(spacing: 40) {
						Text("welcome Back")
							.font(.largeTitle)
							.textCase(.uppercase)
						Text("Who is logging in Today?")
							.font(.caption)
					}
					
					LazyVGrid (columns: columns, spacing: 20) {
						ForEach(profiles) { profile in
							NavigationLink(value: profile) {
								VStack {
									Image(profile.profileImage)
										.resizable()
										.scaledToFit()
										.clipShape(RoundedRectangle(cornerRadius: 22))
									Text(profile.name)
										.font(.system(.headline,design: .rounded))
										.fontWeight(.bold)
								}
							}
						}
					}
				}
			}
			
			.navigationTitle("Profiles Menu")
			.navigationDestination(for: Profile.self) { selectedProfiles in
				if let index = profiles.firstIndex(where: {$0.id == selectedProfiles.id}) {
					ContentView(profiles: $profiles[index])
				}
			}
		}
    }
}
