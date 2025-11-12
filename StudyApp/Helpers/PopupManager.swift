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
    var onClose: (() -> Void)? // <-- Add this

    func show(title: String, image: String, message: String, onClose: (() -> Void)? = nil) {
        withAnimation {
            self.title = title
            self.image = image
            self.message = message
            self.onClose = onClose
            self.isVisible = true
        }
        // Optional: keep auto-dismiss for legacy cases
        // If you want to auto-dismiss ONLY if onClose is nil, use:
        if onClose == nil {
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                guard let self else { return }
                withAnimation { self.isVisible = false }
            }
        }
    }
}
