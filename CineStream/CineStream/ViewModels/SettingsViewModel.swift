//
//  SettingsViewModel.swift
//  CineStream
//
//  Created by Akash Ingawale on 24/05/25.
//

import Foundation

class SettingsViewModel: ObservableObject {

    // MARK: Public methods

    func currentDate() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: today)
    }

}
