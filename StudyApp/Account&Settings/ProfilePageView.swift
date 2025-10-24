// MARK: - 1. Profile Data Model & Utility

import SwiftUI

/// Defines the structure for the user's profile data.
struct Profile {
    var name: String = "Marvin McKinney"
    var email: String = "marvin@email.com"
    var dateOfBirth: Date = Calendar.current.date(from: DateComponents(year: 1997, month: 11, day: 8)) ?? Date()
    var phoneNumber: String = "702-889-5347"
    var studentID: String = "#87654"
    var gender: Gender = .male
    var address: String = "1106 Sunrise Road Las Vegas, NV 89102"
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
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
}

// MARK: - 2. Main Profile View

/// Custom color to match the image's blue theme.
private let primaryAppColor = Color(red: 0.1, green: 0.5, blue: 0.9)

struct ProfilePageView: View {
    // State to hold the profile data and manage the view's state
    @State private var profile = Profile()
    @State private var showingAlert = false
    @State private var alertMessage = ""

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
            return false
        }
        
        // Phone number: Simple check for non-emptiness (a more robust regex is usually needed)
        guard !profile.phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Phone Number is required."
            return false
        }
        
        // Address must not be empty
        guard !profile.address.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Address is required."
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
                // MARK: Navigation Header
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                    Spacer()
                    Text("Profil")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    // Invisible element to balance the chevron icon position
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .opacity(0)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 20)
                .background(Color.white) // Ensures the header is on a white background

                // MARK: Scrollable Form Content
                ScrollView {
                    VStack(spacing: 15) {
                        
                        // MARK: Profile Picture
                        ProfilePictureView()
                            .padding(.bottom, 20)

                        // MARK: Form Fields
                        FormTextFieldd(title: "Name", text: $profile.name)
                        FormTextFieldd(title: "Email", text: $profile.email, keyboardType: .emailAddress)
                        
                        // Date of Birth Selector
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Date of birth")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            DatePicker("", selection: $profile.dateOfBirth, displayedComponents: .date)
                                .datePickerStyle(.compact) // iOS 16+ uses this style for text field appearance
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .labelsHidden() // Hide the "Date of birth" label from the date picker itself
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }

                        FormTextFieldd(title: "Phone Number", text: $profile.phoneNumber, keyboardType: .phonePad)
                        
                        // Student ID Field (Read-only appearance with no text field style)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Student ID")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(profile.studentID)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.1)) // Light gray background
                                .cornerRadius(10)
                        }

                        // MARK: Gender Selection
                        GenderSelectorView(selectedGender: $profile.gender)

                        // MARK: Address Text Area
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Address")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $profile.address)
                                .frame(minHeight: 100, maxHeight: 150)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.top, 5)
                        }
                        .padding(.top, 10)
                        
                        // MARK: Update Button
                        Button(action: {
                            if isFormValid {
                                // Logic to save/update profile goes here
                                alertMessage = "Profile updated successfully!"
                                showingAlert = true
                            } else {
                                // Validation failed, alert message is already set by isFormValid
                                showingAlert = true
                            }
                        }) {
                            Text("Update Profil")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(primaryAppColor)
                                .cornerRadius(15) // Slightly rounded to match the image
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40) // Extra padding for the scroll view content
                    }
                    .padding(.horizontal, 25) // Horizontal padding for the form content
                }
            }
        }
        .alert("Update Status", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
}


// MARK: - 3. Helper Views

/// A reusable view for a text input field with a floating-style title.
struct FormTextFieldd: View {
    var title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            if isSecure {
                SecureField("", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                TextField("", text: $text)
                    .keyboardType(keyboardType)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
}

/// The profile picture component with an integrated camera icon.
struct ProfilePictureView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Profile Image (using a system image as a placeholder)
            Image(systemName: "person.circle.fill") // Placeholder: In a real app, use a Kingfisher or AsyncImage
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .foregroundColor(Color.gray.opacity(0.3)) // Light gray color for the circle background

            // Camera Icon Button
            Button(action: {
                // Action to open photo library/camera
            }) {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(primaryAppColor) // Blue background for the icon
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2)) // White border
            }
            .offset(x: 5, y: 5) // Slightly offset to match the image
        }
    }
}

/// Custom view for Gender Selection using two styled buttons.
struct GenderSelectorView: View {
    @Binding var selectedGender: Gender

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Gender")
                .font(.caption)
                .foregroundColor(.gray)
            
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
        ProfilePageView()
    }
}
