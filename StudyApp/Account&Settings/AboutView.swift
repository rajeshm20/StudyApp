//
//  AboutUsView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/10/25.
//

import SwiftUI

struct AboutView: View {
    var router:Router<MainRoute>
    var body: some View {
        VStack {
            List {
                Button(action: {
                    router.push(.aboutUs)
                }) {
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
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView(router: Router<MainRoute>())
}
