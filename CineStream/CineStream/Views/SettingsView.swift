//
//  SettingsView.swift
//  CineStream
//
//  Created by Akash Ingawale on 23/05/25.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Properties

    @StateObject private var viewModel = SettingsViewModel()

    @State private var isDarkModeEnabled = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkModeEnabled)
                        .onChange(of: isDarkModeEnabled) { newValue in
                            if newValue {
                                alertTitle = "Enabled Dark mode"
                                alertMessage = "Enabled Dark mode"
                            } else {
                                alertTitle = "Disable Dark mode"
                                alertMessage = "Disable Dark mode"
                            }
                            showAlert = true
                        }
                }
                
                Section(header: Text("Data Management")) {
                    Button("Clear Image Cache") {
                        ImageCacheService.shared.clearCache()
                        alertTitle = "Cache Cleared"
                        alertMessage = "Image cache has been successfully cleared."
                        showAlert = true
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()


                        Text(viewModel.currentDate())
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
