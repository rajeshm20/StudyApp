//
//  AboutView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/10/25.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    var router: Router<MainRoute>

    var body: some View {
        VStack {
            List {
                Button(action: {
                    router.push(.aboutUs)
                }) {
                    Text(localizationService.text(.aboutUs))
                }
                Button(action: {}) {
                    Text(localizationService.text(.help))
                }
                Button(action: {
                    router.push(.termsConditions)
                }) {
                    Text(localizationService.text(.termsAndConditions))
                }
                Button(action: {
                    router.push(.datapolicy)
                }) {
                    Text(localizationService.text(.dataPolicy))
                }
            }
            .font(.headline)
            .foregroundStyle(.black)
        }
        .navigationTitle(localizationService.text(.aboutTitle))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView(router: Router<MainRoute>())
}
