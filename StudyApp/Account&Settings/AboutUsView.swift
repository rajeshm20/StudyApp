//
//  AboutUsView!.swift
//  StudyApp
//
//  Created by Rajesh Mani on 26/10/25.
//

import SwiftUI

struct AboutUsView: View {
    var router: Router<MainRoute>
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("About Us?")
                    .titleStyle()
                    .padding()
                Text("""
                     Add new navigation methods to protocol as your flow complexity grows.

                     Router tracks all navigation state centrally, facilitating flexible navigation.

                     Each module remains decoupled and only knows protocol, supporting deep linking, pop, or tab scenarios.

                     You can extend this further for sheet presentations, modals, child coordinators—all via protocol and state in the centralized router.
                     Let me know which pattern or scenario you’d like a deeper code sample for! 
                    """)
                    .subtitleStyle()
                    .padding()
                Spacer()
                Text("Business")
                    .titleStyle()
                    .padding()
                Text("""
                     Add new navigation methods to protocol as your flow complexity grows.

                     Router tracks all navigation state centrally, facilitating flexible navigation.

                     Each module remains decoupled and only knows protocol, supporting deep linking, pop, or tab scenarios.

                     You can extend this further for sheet presentations, modals, child coordinators—all via protocol and state in the centralized router.
                     Let me know which pattern or scenario you’d like a deeper code sample for! 
                    """)
                    .subtitleStyle()
                    .padding()
                Spacer()
            }
            .accentColor(.black)
            .padding()
        }
    }
}

#Preview {
    AboutUsView(router: Router<MainRoute>())
}
