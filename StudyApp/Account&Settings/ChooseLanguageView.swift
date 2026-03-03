//
//  ChooseLanguageView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 23/10/25.
//

import SwiftUI

struct ChooseLanguageView: View {
    @StateObject private var viewModel = LanguageViewModel()
    var router = Router<MainRoute>()

    var body: some View {
        VStack {
            // Search bar with search lens icon
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $viewModel.searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)

            // List of languages
            List(viewModel.filteredLanguages) { language in
                HStack {
                    Text(language.flagEmoji)
                        .font(.system(.largeTitle))

                    Text(language.name)
                        .font(.system(.title3, weight: .bold))
                        .font(.body)
                        .foregroundColor(.primary)

                    Spacer()

                    if viewModel.selectedLanguage?.id == language.id {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectedLanguage = language
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Choose your language")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadLanguages()
        }
    }
}

#Preview {
    ChooseLanguageView()
}
