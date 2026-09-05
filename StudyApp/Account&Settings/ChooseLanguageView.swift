//
//  ChooseLanguageView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 23/10/25.
//

import SwiftUI

struct ChooseLanguageView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    @StateObject private var viewModel = LanguageViewModel()
    var router: Router<MainRoute>

    var body: some View {
        VStack(spacing: 16) {
            Text(localizationService.text(.chooseLanguageDescription))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField(localizationService.text(.commonSearch), text: $viewModel.searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)

            List(viewModel.filteredLanguages) { language in
                HStack {
                    Text(language.flagEmoji)
                        .font(.system(.largeTitle))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(language.nativeName)
                            .font(.system(.title3, weight: .bold))
                            .foregroundColor(.primary)

                        Text(language.accessibilityName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if viewModel.selectedLanguage == language {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.select(language: language)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle(localizationService.text(.chooseLanguageTitle))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.configure(with: localizationService)
        }
    }
}

#Preview {
    ChooseLanguageView(router: Router<MainRoute>())
}
