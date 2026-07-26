// ValidationHelper.swift
import Foundation

enum ValidationHelper {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    // Expected format: "0334 xxxx xxxx" (4+4+4 digits with spaces)
    static func isValidPhoneNumber(_ number: String) -> Bool {
        let phoneRegex = "^\\d{4} \\d{4} \\d{4}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePred.evaluate(with: number)
    }

    // At least 1 letter and 1 number; length rule enforced by caller
    static func isValidPassword(_ password: String) -> Bool {
        let hasLetters = password.contains { $0.isLetter }
        let hasNumbers = password.contains { $0.isNumber }
        return hasLetters && hasNumbers
    }
    static func isValidOTP(_ otp: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", #"^\d{6}$"#)
        return predicate.evaluate(with: otp)
    }

    struct FieldErrors {
        var name: String?
        var email: String?
        var password: String?
        var phoneNumber: String?
        var terms: String?

        var allNilAndValid: Bool {
            name == nil &&
                email == nil &&
                password == nil &&
                phoneNumber == nil &&
                terms == nil
        }
    }

    static func validateAll(name: String,
                            email: String,
                            password: String,
                            phoneNumber: String,
                            agreeToTerms: Bool) -> FieldErrors
    {
        var errors = FieldErrors()

        // Name
        if name.isEmpty {
            errors.name = "Name cannot be empty"
        }

        // Email
        if !isValidEmail(email) {
            errors.email = "Please enter a valid email"
        }

        // Password
        if password.isEmpty {
            errors.password = "Password cannot be empty"
        } else if password.count < 6 {
            errors.password = "Password must be at least 6 characters"
        } else if !isValidPassword(password) {
            errors.password = "Password must contain both letters and numbers"
        }

        // Phone
        if !isValidPhoneNumber(phoneNumber) {
            errors.phoneNumber = "Please enter a valid phone number"
        }

        // Terms
        if !agreeToTerms {
            errors.terms = "You must agree to the terms"
        }

        return errors
    }
}
