//
//  SettingsView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/10/25.
//

import SwiftUI

struct SettingsView: View {
    var router: Router<MainRoute>
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string:"https://images.pexels.com/photos/6483237/pexels-photo-6483237.jpeg")) {
                phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio( contentMode: .fill)
                        .frame(width: 200, height: 300)
                case .failure:
                    Image(systemName: "photo")
                        .imageScale(.large)
                @unknown default:
                      EmptyView()
                }
            }
            VStack {
                List {
                    Button(action: {
                        router.push(.countries)
                    }) {
                        Text("App language")
                    }
                    Button(action: {
                        router.push(.notifications)
                    }) {
                        Text("Notification")
                    }
                    Button(action: {}) {
                        Text("Update version")
                    }
                }
                .opacity(0.5)
                .font(.headline)
                .foregroundStyle(.black)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView(router: Router<MainRoute>())
    
    ImageGridView()
}
enum AppImage: String, CaseIterable, Identifiable {
    case mobilefemale
    case smilyFemale1
    case smilyFemale2
    case studyFemale1
    case StudyingFemale
    case zenchung

    var id: String { rawValue }
}

import SwiftUI

struct ImageGridCell: View {
    let image: AppImage
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        ZStack {
            Image(image.rawValue)
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
                .cornerRadius(12)

            if isSelected {
                Color.black.opacity(0.4)

                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct ImageGridView: View {
    @State private var viewModel = ImageGridViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {

                ForEach(AppImage.allCases) { image in

                    ImageGridCell(
                        image: image,
                        isSelected: viewModel.selectedImages.contains(image)
                    ) {

                        viewModel.toggle(image)
                    }
                }
            }
            .padding()
        }
    }

//    private func toggleSelection(for image: AppImage) {
//        if selectedImages.contains(image) {
//            selectedImages.remove(image)
//        } else {
//            selectedImages.insert(image)
//        }
//    }
}
@Observable
final class ImageGridViewModel {

    var selectedImages: Set<AppImage> = []

    func toggle(_ image: AppImage) {
        if selectedImages.contains(image) {
            selectedImages.remove(image)
        } else {
            selectedImages.insert(image)
        }
    }
}
