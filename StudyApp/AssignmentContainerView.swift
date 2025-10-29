//
//  AssignmentContainerView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 26/10/25.
//
import SwiftUI

// MARK: - Root View

struct AssignmentContainerView: View {
    @State private var showListView = false
    var router: Router<MainRoute>

    var body: some View {
        if showListView {
            AssignmentsListView(showListView: $showListView, router: router)
        } else {
            AssignmentCalendarScreen(showListView: $showListView)
        }
    }
}

#Preview {
    AssignmentContainerView(router: Router<MainRoute>())
}
