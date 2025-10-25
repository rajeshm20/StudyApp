//
//  PopupManager.swift
//  StudyApp
//
//  Created by Rajesh Mani on 19/10/25.
//
import Foundation
import SwiftUI

// 1️⃣ Popup Manager
@MainActor
class PopupManager: ObservableObject {
    @Published var isVisible = false
    @Published var title = ""
    @Published var image = ""
    @Published var message = ""
    
    func show(title: String, image: String, message: String) {
        withAnimation {
            self.title = title
            self.image = image
            self.message = message
            self.isVisible = true
        }
        // Auto dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            withAnimation { self.isVisible = false }
        }
    }
}
