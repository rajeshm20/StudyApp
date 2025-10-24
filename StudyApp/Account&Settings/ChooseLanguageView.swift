import SwiftUI

struct ChooseLanguageView: View {
    @StateObject private var viewModel = LanguageViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // List of languages
                List(viewModel.filteredLanguages) { language in
                    HStack {
                        Text(language.flagEmoji)
                            .font(.title2)

                        Text(language.name)
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
}