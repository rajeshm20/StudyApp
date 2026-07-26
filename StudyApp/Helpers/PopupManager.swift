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
    @Published var primaryButtonTitle = "Close"
    @Published var secondaryButtonTitle: String?
    var onPrimary: (() -> Void)?
    var onSecondary: (() -> Void)?

    func show(
        title: String,
        image: String,
        message: String,
        primaryButtonTitle: String = "Close",
        secondaryButtonTitle: String? = nil,
        onPrimary: (() -> Void)? = nil,
        onSecondary: (() -> Void)? = nil
    ) {
        withAnimation {
            self.title = title
            self.image = image
            self.message = message
            self.primaryButtonTitle = primaryButtonTitle
            self.secondaryButtonTitle = secondaryButtonTitle
            self.onPrimary = onPrimary
            self.onSecondary = onSecondary
            self.isVisible = true
        }
    }

    func dismiss() {
        withAnimation {
            isVisible = false
        }
        onPrimary = nil
        onSecondary = nil
        secondaryButtonTitle = nil
        primaryButtonTitle = "Close"
    }
}
