// MARK: - Reusable Form Field View with Validation
struct FormField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    @Binding var error: String?
    var isPhoneNumber: Bool = false
    var completion: () -> Void
    var isDatePicker: Bool = false
    @Binding var date: Date?
    @Binding var showDatePicker: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)

            if isSecure {
                SecureField(placeholder, text: $text, onCommit: {
                    completion()
                })
                .onChange(of: text) {
                    completion()
                }
                .padding()
                .background(Color.themee.background.opacity(0.4))
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1.5)) // Border
                .cornerRadius(8)
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
                .keyboardType(keyboardType)
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .sentences)
                .padding()
                .background(Color.themee.background.opacity(0.4))
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1.5)) // Border
                .cornerRadius(8)
            }

            // Display validation error if exists
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }
        }
        .padding([.horizontal, .vertical], 5)

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
