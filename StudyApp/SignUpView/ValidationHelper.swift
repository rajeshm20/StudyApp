// ValidationHelper.swift
// Mirrors the validation constraints defined in the backend's ValidationUtilities.swift.
// Keep these rules in sync whenever the backend changes StudentValidationConstraints.

import Foundation

enum ValidationHelper {

    // MARK: - Email

    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    // MARK: - Password
    // Backend requires >= 8 chars (StudentValidationConstraints.passwordMinLength = 8)
    // plus at least one letter AND one number.

    /// Minimum password length, must match `StudentValidationConstraints.passwordMinLength`.
    static let passwordMinLength = 8

    /// Returns true only when the password meets length AND complexity rules.
    static func isValidPassword(_ password: String) -> Bool {
        guard password.count >= passwordMinLength else { return false }
        let hasLetters = password.contains { $0.isLetter }
        let hasNumbers = password.contains { $0.isNumber }
        return hasLetters && hasNumbers
    }

    // MARK: - Country Code
    // Must start with '+' followed by 1–4 digits (e.g. "+1", "+91", "+353").
    // Mirrors CountryCodeValidator in backend ValidationUtilities.swift.

    static func isValidCountryCode(_ code: String) -> Bool {
        let pattern = "^\\+[1-9][0-9]{0,3}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: code)
    }

    // MARK: - Contact Number (digits only, no country code)
    // 7–15 digits, no spaces or dashes — only the subscriber portion.
    // Mirrors ContactNumberValidator in backend ValidationUtilities.swift.

    static let contactNumberMinLength = 7
    static let contactNumberMaxLength = 15

    static func isValidContactNumber(_ number: String) -> Bool {
        guard number.allSatisfy({ $0.isNumber }) else { return false }
        return number.count >= contactNumberMinLength && number.count <= contactNumberMaxLength
    }

    // MARK: - Legacy Phone Number (combined field — kept for backward compatibility)
    // Expected format: "0334 xxxx xxxx" (4+4+4 digits with spaces)

    static func isValidPhoneNumber(_ number: String) -> Bool {
        let phoneRegex = "^\\d{4} \\d{4} \\d{4}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePred.evaluate(with: number)
    }

    // MARK: - OTP

    static func isValidOTP(_ otp: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", #"^\d{6}$"#)
        return predicate.evaluate(with: otp)
    }

    // MARK: - Batch Validation (New Canonical Signup)

    /// Field error bag for the new canonical signup form.
    struct NewSignupFieldErrors {
        var firstName: String?
        var lastName: String?
        var email: String?
        var password: String?
        var confirmPassword: String?
        var countryCode: String?
        var contactNumber: String?
        var terms: String?

        var isAllValid: Bool {
            firstName == nil &&
            lastName == nil &&
            email == nil &&
            password == nil &&
            confirmPassword == nil &&
            countryCode == nil &&
            contactNumber == nil &&
            terms == nil
        }
    }

    static func validateNewSignup(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        confirmPassword: String,
        countryCode: String,
        contactNumber: String,
        agreeToTerms: Bool
    ) -> NewSignupFieldErrors {
        var errors = NewSignupFieldErrors()

        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.firstName = "First name cannot be empty"
        }
        if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.lastName = "Last name cannot be empty"
        }
        if !isValidEmail(email) {
            errors.email = "Please enter a valid email"
        }
        if password.isEmpty {
            errors.password = "Password cannot be empty"
        } else if password.count < passwordMinLength {
            errors.password = "Password must be at least \(passwordMinLength) characters"
        } else if !isValidPassword(password) {
            errors.password = "Password must contain both letters and numbers"
        }
        if password != confirmPassword {
            errors.confirmPassword = "Passwords do not match"
        }
        if !isValidCountryCode(countryCode) {
            errors.countryCode = "Enter a valid country code (e.g. +91)"
        }
        if !isValidContactNumber(contactNumber) {
            errors.contactNumber = "Enter a valid phone number (\(contactNumberMinLength)–\(contactNumberMaxLength) digits)"
        }
        if !agreeToTerms {
            errors.terms = "You must agree to the terms"
        }

        return errors
    }

    // MARK: - Legacy Batch Validation (kept for any existing callers)

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

        if name.isEmpty {
            errors.name = "Name cannot be empty"
        }
        if !isValidEmail(email) {
            errors.email = "Please enter a valid email"
        }
        if password.isEmpty {
            errors.password = "Password cannot be empty"
        } else if password.count < passwordMinLength {
            errors.password = "Password must be at least \(passwordMinLength) characters"
        } else if !isValidPassword(password) {
            errors.password = "Password must contain both letters and numbers"
        }
        if !isValidPhoneNumber(phoneNumber) {
            errors.phoneNumber = "Please enter a valid phone number"
        }
        if !agreeToTerms {
            errors.terms = "You must agree to the terms"
        }

        return errors
    }
}
