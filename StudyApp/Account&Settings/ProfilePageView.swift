// MARK: - 1. Profile Data Model & Utility

import PhotosUI
import SwiftUI

/// Defines the structure for the user's profile data.
struct Profile {
    var name: String = "Shashanth R N"
    var email: String = "shashanthrn@rnss.com"
    var dateOfBirth: Date = Calendar.current.date(from: DateComponents(year: 1997, month: 11, day: 8)) ?? Date()
    var phoneNumber: String = "702-889-5347"
    var studentID: String = "#87654"
    var gender: Gender = .male
    var address: String = "25, J J Dev's Apartments, \nBangalore, IN"
}

/// Simple enum for gender selection.
enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}

/// Extension for basic email validation.
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
}

// MARK: - 2. Main Profile View

/// Custom color to match the image's blue theme.
private let primaryAppColor = Color(red: 0.1, green: 0.5, blue: 0.9)

struct ProfilePageView: View {
    // State to hold the profile data and manage the view's state
    @State private var profile = Profile()
    @State private var alertMessage = ""
    // Per-field error state to satisfy FormField(error: Binding<String?>)
    @State private var nameError: String? = nil
    @State private var emailError: String? = nil
    @State private var dobError: String? = nil
    @State private var phoneNoError: String? = nil
    @State private var addressError: String? = nil
    @State private var selectedGender: Gender = .male
    // Date field state for FormField date mode
    @State private var dob: Date? = nil
    @State private var showDOBPicker: Bool = false
    // A placeholder text binding for FormField API (unused in date mode)
    @State private var dobText: String = ""
    @EnvironmentObject var popupManager: PopupManager
    var router: Router<MainRoute>

    // Computed property for form validation
    var isFormValid: Bool {
        // Name must not be empty
        guard !profile.name.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Name is required."
            return false
        }

        // Email must be non-empty and valid
        guard profile.email.isValidEmail else {
            alertMessage = "Please enter a valid email address."
            return false
        }

        // Date of Birth: Simple check to ensure it's not in the future (optional: you could add an age check)
        guard profile.dateOfBirth < Date() else {
            alertMessage = "Date of Birth cannot be in the future."
            dobError = alertMessage
            return false
        }

        // Phone number: Simple check for non-emptiness (a more robust regex is usually needed)
        guard !profile.phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Phone Number is required."
            phoneNoError = alertMessage
            return false
        }

        // Address must not be empty
        guard !profile.address.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Address is required."
            addressError = alertMessage
            return false
        }

        // If all checks pass
        return true
    }

    var body: some View {
        // Use a ZStack to layer the navigation bar content over the scroll view
        ZStack(alignment: .top) {
            // White background for the form
            Color.white.edgesIgnoringSafeArea(.all)

            // Outer blue border/background color from the image
            VStack {
                Spacer()
                // A blue frame to mimic the light-blue container background from the image
                Color(red: 0.9, green: 0.95, blue: 1.0)
                    .frame(height: 100)
            }
            .edgesIgnoringSafeArea(.bottom)

            VStack(spacing: 0) {
                // MARK: Scrollable Form Content

                ScrollView {
                    VStack(spacing: 15) {
                        // MARK: Profile Picture

//                        ProfileHeader(imageName: "student3")
//                            .padding(.bottom, 20)
                        ProfilePictureView()
                            .padding([.top, .bottom], 20)

                        // MARK: Form Fields

                        FormField(title: "Name", placeholder: "Your name", text: $profile.name, error: $nameError, completion: {
                            // Example inline validation to update nameError
                            nameError = profile.name.trimmingCharacters(in: .whitespaces).isEmpty ? "Name is required" : nil
                        })
                        FormField(title: "Email",
                                  placeholder: "Your name",
                                  text: $profile.email,
                                  error: $emailError,
                                  completion: {
                                      // Example inline validation to update emailError
                                      emailError = profile.email.trimmingCharacters(in: .whitespaces).isEmpty ? "Email is required" : (profile.email.isValidEmail ? nil : "Please enter a valid email")
                                  })

                        // Date of Birth using FormField date mode
                        FormField(
                            title: "Date of Birth",
                            placeholder: "Select date",
                            text: $dobText,
                            error: $dobError,
                            usesDatePicker: true,
                            date: $dob,
                            showDatePicker: $showDOBPicker,
                            displayedComponents: .date,
                            maximumDate: Date(), // no future dates
                            completion: {
                                if let picked = dob {
                                    profile.dateOfBirth = picked
                                    dobError = (picked > Date()) ? "Date of Birth cannot be in the future." : nil
                                } else {
                                    dobError = "Date of Birth is required."
                                }
                            }
                        )

                        FormField(title: "Phone Number",
                                  placeholder: "Your name",
                                  text: $profile.phoneNumber,
                                  error: $phoneNoError,
                                  isPhoneNumber: true,
                                  completion: {
                                      // Example inline validation to update phone error
                                      phoneNoError = profile.phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty ? "Phone number is required" : nil
                                  })
                        FormField(title: "Student ID",
                                  placeholder: "",
                                  text: $profile.studentID,
                                  error: $dobError,
                                  isBackgroundColorEnabled: true,
                                  completion: {
                                      dobError = alertMessage
                                  })
                                  .disabled(true)
                        // Student ID Field (Read-only appearance with no text field style)

                        // MARK: Gender Selection

                        GenderSelectorView(selectedGender: $profile.gender)
                            .padding(.horizontal, 10)

                        // MARK: Address Text Area

                        FormField(title: "Address", placeholder: "", text: $profile.address, error: $addressError, isTextEditorEnabled: true, completion: {})
                            .padding(.top, 10)

                        // MARK: Update Button

                        AppButton(
                            title: "Update Profile",
                            style: .filled,
                            foregroundColor: .white,
                            backgroundColor: .cyan,
                            cornerRadius: 8,
                            font: .system(size: 18, weight: .bold),
                            fullWidth: true,
                            isLoading: false,
                            isDisabled: false
                        ) {
                            if isFormValid {
                                // Logic to save/update profile goes here
                                alertMessage = "Profile updated successfully!"
                                popupManager.show(
                                    title: "Profile updated",
                                    image: "tick_round",
                                    message: "Tap accept button to confirm entered details are correct.",
                                    onClose: {
                                        // Dynamic navigation or any logic goes here:
                                        router.pop()
                                        popupManager.isVisible = false // Also dismiss the popup
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.horizontal, 25) // Horizontal padding for the form content
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // initialize dob state from profile
            dob = profile.dateOfBirth
        }
//         Keyboard dismiss gesture for entire screen
        .simultaneousGesture(
            TapGesture().onEnded { hideKeyboard() }
        )
    }
}

/// The profile picture component with an integrated camera icon.
struct ProfilePictureView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var savedImageURL: URL?
    @State private var profile = Profile()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Display selected image if available, otherwise placeholder
            Group {
                if let uiImage = selectedImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color.gray.opacity(0.3))
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white.opacity(0.6), lineWidth: 0)
            )

            // Camera Icon Button using PhotosPicker
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(primaryAppColor)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    guard let item = newItem else { return }
                    // Load image data and create a UIImage from it
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data)
                    {
                        selectedImage = image
                        // Save to Documents directory
                        savedImageURL = saveImageToDocuments(image)
                        // You can log or handle the URL as needed
                        if let url = savedImageURL {
                            print("✅ Saved profile image at:", url.path)
                        } else {
                            print("❌ Failed to save profile image.")
                        }
                    } else {
                        // Fallback: try loading as a generic Transferable image representation if available
                        // or leave selectedImage unchanged.
                    }
                }
            }
            .offset(x: 5, y: 5)
        }
        .onAppear {
            loadSavedProfileImage()
        }
    }

    // MARK: - Persistence helpers

    // URL to Documents/profile.jpg
    private var profileImageURL: URL? {
        do {
            let documents = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return documents.appendingPathComponent("profile.jpg")
        } catch {
            print("❌ Could not get Documents directory:", error)
            return nil
        }
    }

    // Save UIImage as JPEG(0.9) to Documents/profile.jpg. Returns file URL if successful.
    private func saveImageToDocuments(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        guard let fileURL = profileImageURL else { return nil }
        do {
            // Overwrite if file exists
            try? FileManager.default.removeItem(at: fileURL)
            try data.write(to: fileURL, options: .atomic)
            print(fileURL)
            return fileURL
        } catch {
            print("❌ Error saving image:", error)
            return nil
        }
    }

    // Load Documents/profile.jpg if it exists and set selectedImage
    @MainActor
    private func loadSavedProfileImage() {
        guard let fileURL = profileImageURL else { return }
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            // No saved image yet
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            if let image = UIImage(data: data) {
                selectedImage = image
                savedImageURL = fileURL
//                print("✅ Loaded saved profile image:", fileURL.path)
            }
        } catch {
            print("❌ Failed to load saved profile image:", error)
        }
    }
}

/// Custom view for Gender Selection using two styled buttons.
struct GenderSelectorView: View {
    @Binding var selectedGender: Gender

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Gender")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)

            HStack(spacing: 15) {
                // Button for Male
                genderButton(for: .male)

                // Button for Female
                genderButton(for: .female)

                Spacer()
            }
        }
    }

    // Helper function to generate a consistent button style
    private func genderButton(for gender: Gender) -> some View {
        Button(action: {
            selectedGender = gender
        }) {
            HStack(spacing: 8) {
                // Checkmark or Radio circle based on selection
                Image(systemName: selectedGender == gender ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedGender == gender ? primaryAppColor : .gray)

                Text(gender.rawValue)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: 150, minHeight: 45) // Fixed width/height for visual balance
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedGender == gender ? primaryAppColor : Color.gray.opacity(0.3), lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Preview

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView(router: Router<MainRoute>())
            .environmentObject(PopupManager())
    }
}
