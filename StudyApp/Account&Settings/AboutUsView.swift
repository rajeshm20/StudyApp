//
//  AboutUsView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/10/25.
//

import SwiftUI

struct AboutUsView: View {
    var router = Router<MainRoute>()
    var body: some View {
        VStack {
            List {
                Button(action: { }) {
                    Text("About Us")
                }
                Button(action: { }) {
                    Text("Help")
                }
                Button(action: {
                    router.push(.termsConditions)
                }) {
                    Text("Terms and Condition")
                }
                Button(action: {
                    router.push(.datapolicy)
                }) {
                    Text("Data Policy")
                }
            }
            .font(.headline)
            .foregroundStyle(.black)
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutUsView()
}
