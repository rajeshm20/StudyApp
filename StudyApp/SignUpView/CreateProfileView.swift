//
//  CreateProfileView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//


import SwiftUI

struct CreateProfileView: View {
    @State private var fullName: String = ""
    @State private var profileImage: UIImage?
    @State private var isImagePickerPresented = false
    var router: Router<AuthRoute> // <-- Take as parameter, don't create new

    var body: some View {
        VStack(spacing: 24) {
            // Title and subtitle
            VStack(spacing: 8) {
                Text("Create your profile")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Text("Provide your profile picture and display your name to make easy delivery")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 20)

            // Profile image picker
            ZStack(alignment: .bottomTrailing) {
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.gray.opacity(0.6))
                        )
                }

                Button(action: {
                    isImagePickerPresented = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 28, height: 28)
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .offset(x: 4, y: 4)
            }

            // Name text field
            TextField("Full Name", text: $fullName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 32)

            Spacer()

            // Continue button
            Button(action: {
                // Handle continue action
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(fullName.isEmpty ? Color.blue.opacity(0.4) : Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
            }
            .disabled(fullName.isEmpty)

            Spacer(minLength: 20)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $profileImage)
        }
    }
}

// MARK: - ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    CreateProfileView(router: Router<AuthRoute>())
}
