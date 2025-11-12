//
//  FormField.swift
//  StudyApp
//
//  Created by Rajesh Mani on 17/10/25.
//
import SwiftUI

// MARK: - Reusable Form Field View with Validation
struct FormField: View {
    // Common
    var title: String
    var placeholder: String
    @Binding var text: String
    @Binding var selectedGender: Gender
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    @Binding var error: String?
    var isPhoneNumber: Bool = false
    var isTextEditorEnabled: Bool = true
    var isBackgroundColorEnabled: Bool = false
    var isDoubleSelectableRadioButtonEnabled: Bool = false
    var completion: () -> Void

    // Date mode
    var usesDatePicker: Bool = false
    @Binding var date: Date?
    @Binding var showDatePicker: Bool
    var displayedComponents: DatePickerComponents = .date
    var minimumDate: Date? = nil
    var maximumDate: Date? = nil
    var dateFormatStyle: Date.FormatStyle = .init(date: .long, time: .omitted)

    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        selectedGender: Binding<Gender> = .constant(.male),
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        error: Binding<String?>,
        isPhoneNumber: Bool = false,
        isTextEditorEnabled: Bool = false,
        isBackgroundColorEnabled: Bool = false,
        isDoubleSelectableRadioButtonEnabled: Bool = false,
        usesDatePicker: Bool = false,
        date: Binding<Date?> = .constant(nil),
        showDatePicker: Binding<Bool> = .constant(false),
        displayedComponents: DatePickerComponents = .date,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil,
        dateFormatStyle: Date.FormatStyle = .init(date: .long, time: .omitted),
        completion: @escaping () -> Void
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self._selectedGender = selectedGender
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self._error = error
        self.isPhoneNumber = isPhoneNumber
        self.isTextEditorEnabled = isTextEditorEnabled
        self.isBackgroundColorEnabled = isBackgroundColorEnabled
        self.isDoubleSelectableRadioButtonEnabled = isDoubleSelectableRadioButtonEnabled
        self.usesDatePicker = usesDatePicker
        self._date = date
        self._showDatePicker = showDatePicker
        self.displayedComponents = displayedComponents
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.dateFormatStyle = dateFormatStyle
        self.completion = completion
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)

            if usesDatePicker {
                dateField
                if showDatePicker {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { date ?? Date() },
                            set: { newValue in
                                date = newValue
                                completion()
                            }
                        ),
                        displayedComponents: displayedComponents
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .environment(\.locale, Locale.current)
                    .onChange(of: date) { _, _ in
                        // can add extra validation if needed
                        if let min = minimumDate, let current = date, current < min {
                            date = min
                        }
                        if let max = maximumDate, let current = date, current > max {
                            date = max
                        }

                    }
                    .onAppear {
                        // Clamp initial date within bounds if provided
                        if let min = minimumDate, let current = date, current < min {
                            date = min
                        }
                        if let max = maximumDate, let current = date, current > max {
                            date = max
                        }
                    }
                    .padding(.top, 4)
                }
            } else if self.isTextEditorEnabled {
                VStack(alignment: .leading, spacing: 5) {
                    TextEditor(text: self.$text)
                        .onChange(of: text) {
                            completion()
                        }
                        .frame(maxWidth: .infinity, minHeight: 150, alignment: .init(horizontal: .leading, vertical: .top))
                        .foregroundStyle(self.text.isEmpty ? .textSecondary: .primary)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.top, 5)
                }
                .padding(.top, 10)
                .padding(.horizontal, 10)

            } else if self.isDoubleSelectableRadioButtonEnabled {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 15) {
                        // Button for Male
                        genderButton(for: .male)
                        // Button for Female
                        genderButton(for: .female)
                        Spacer()
                    }
                }
            } else {
                if isSecure {
                    SecureField(placeholder, text: $text, onCommit: {
                        completion()
                    })
                    .onChange(of: text) {
                        completion()
                    }
                    .roundedTextFieldStyle(backgroundColor: .appBackground)
                } else {
                    TextField(placeholder, text: $text, onCommit: {
                        completion()
                    })
                    .onChange(of: text) { oldValue, newValue in
                        if isPhoneNumber {
                            text = formatPhoneNumber(newValue)
                        }
                        completion()
                    }
                    .roundedTextFieldStyle(backgroundColor: .appBackground)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .sentences)
                }
            }

            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }
        }
        .padding([.horizontal, .vertical], 5)
    }
    
    private func genderButton(for gender: Gender) -> some View {
        Button(action: {
            selectedGender = gender
            completion() // 👈 Call completion when gender is changed
        }) {
            HStack(spacing: 8) {
                Image(systemName: selectedGender == gender ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedGender == gender ? .primary : .gray)

                Text(gender.rawValue)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: 150, minHeight: 45)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedGender == gender ? .primary : Color.gray.opacity(0.3), lineWidth: 1.5)
            )
        }
    }
    private var dateField: some View {
        Button {
            withAnimation {
                showDatePicker.toggle()
            }
        } label: {
            HStack {
                let hasDate = (date != nil)
                Text(hasDate ? formattedDate(date!) : placeholder)
                    .foregroundColor(hasDate ? .primary : .gray)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(showDatePicker ? 180 : 0))
                    .animation(.easeInOut(duration: 0.2), value: showDatePicker)
            }
            .roundedTextFieldStyle(backgroundColor: .appBackground)
        }
        .buttonStyle(.plain)
    }

    private func formattedDate(_ date: Date) -> String {
        date.formatted(dateFormatStyle)
    }

    func formatPhoneNumber(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        // Limit to 12 digits (4+4+4)
        let truncatedDigits = String(digits.prefix(12))
        
        var formatted = ""
        for (index, digit) in truncatedDigits.enumerated() {
            if index == 4 || index == 8 {
                formatted += " "
            }
            formatted += String(digit)
        }
        return formatted
    }

}

extension FormField {
    
}
