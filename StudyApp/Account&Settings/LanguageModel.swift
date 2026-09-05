import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case hindi = "hi"

    var id: String { rawValue }

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    var flagEmoji: String {
        switch self {
        case .english:
            "🇺🇸"
        case .hindi:
            "🇮🇳"
        }
    }

    var nativeName: String {
        switch self {
        case .english:
            "English"
        case .hindi:
            "हिन्दी"
        }
    }

    var accessibilityName: String {
        switch self {
        case .english:
            "English"
        case .hindi:
            "Hindi"
        }
    }
}

enum AppLocalizationKey {
    case appName
    case commonSearch
    case commonOk
    case commonComingSoon
    case launchTitle
    case launchSubtitle
    case launchStartButton
    case launchLanguageLabel
    case chooseLanguageTitle
    case chooseLanguageDescription
    case settingsTitle
    case settingsAppLanguage
    case settingsNotifications
    case settingsUpdateVersion
    case settingsWelcome
    case settingsPrivacyPolicy
    case settingsTerms
    case settingsLogoutTitle
    case settingsLogoutMessage
    case settingsLogoutYes
    case settingsLogoutNo
    case settingsLoggingOutTitle
    case settingsLoggingOutMessage
    case settingsLoggedOutTitle
    case settingsLogoutFailedTitle
    case aboutTitle
    case aboutUs
    case help
    case termsAndConditions
    case dataPolicy
    case dashboardGreeting
    case dashboardLoading
    case dashboardFailedToLoad
    case dashboardPresence
    case dashboardCompleteness
    case dashboardAssignments
    case dashboardTotalSubjects
    case dashboardSchedule
    case dashboardCourse
    case dashboardSubjects
    case dashboardClass
    case dashboardCalendar
    case dashboardProfile
    case authSignIn
    case authSignUp
    case authForgotPassword
    case authForgotPasswordDescription
    case authVerifyEmail
    case authEmailVerifiedTitle
    case authCheckYourEmail
    case authSigningInTitle
    case authSigningInMessage
    case authSignInFailed
    case authSignedInTitle
    case authSignedInMessage
    case authDontHaveAccount
    case authOr
    case authEmail
    case authPassword
    case authPasswordPlaceholder
    case authName
    case authNamePlaceholder
    // New canonical signup fields
    case authFirstName
    case authFirstNamePlaceholder
    case authLastName
    case authLastNamePlaceholder
    case authCountryCode
    case authCountryCodePlaceholder
    case authContactNumber
    case authContactNumberPlaceholder
    case authConfirmPassword
    case authConfirmPasswordPlaceholder
    case authPhoneNumber
    case authPhonePlaceholder
    case authAgreeTermsPrefix
    case authAgreeTermsLink
    case authAgreeTermsSuffix
    case authCreatingAccountTitle
    case authCreatingAccountMessage
    case authAccountCreatedTitle
    case authAccountCreatedMessage
    case authSignUpFailed
    case authVerifyCodeTitle
    case authVerifyCodeDescription
    case authVerify
    case authResendCode
    case authInvalidEmail
    case authEmptyName
    case authEmptyFirstName
    case authEmptyLastName
    case authInvalidPhone
    case authInvalidCountryCode
    case authInvalidContactNumber
    case authConfirmPasswordMismatch
    case authTermsRequired
    case authEmptyPassword
    case authPasswordShort
    case authPasswordWeak
    case onboardingTitleOne
    case onboardingDescriptionOne
    case onboardingTitleTwo
    case onboardingDescriptionTwo
    case onboardingTitleThree
    case onboardingDescriptionThree
    case onboardingSkip
    case onboardingNext
    case onboardingCurrentPage
    case onboardingPage
    case notificationTitle
    case notificationEmail
    case notificationEmailSubtitle
    case notificationUpdates
    case notificationUpdatesSubtitle
    case notificationRecommendations
    case notificationRecommendationsSubtitle
    case notificationMessages
    case notificationMessagesSubtitle
}

protocol LanguageRepository {
    func fetchSupportedLanguages() -> [AppLanguage]
    func fetchSelectedLanguage() -> AppLanguage
    func saveSelectedLanguage(_ language: AppLanguage)
}

struct UserDefaultsLanguageRepository: LanguageRepository {
    private enum StorageKey {
        static let selectedLanguage = "study_app.selected_language"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func fetchSupportedLanguages() -> [AppLanguage] {
        AppLanguage.allCases
    }

    func fetchSelectedLanguage() -> AppLanguage {
        guard
            let rawValue = defaults.string(forKey: StorageKey.selectedLanguage),
            let language = AppLanguage(rawValue: rawValue)
        else {
            return .english
        }

        return language
    }

    func saveSelectedLanguage(_ language: AppLanguage) {
        defaults.set(language.rawValue, forKey: StorageKey.selectedLanguage)
    }
}

@MainActor
final class LocalizationService: ObservableObject {
    @Published private(set) var currentLanguage: AppLanguage

    let supportedLanguages: [AppLanguage]

    private let repository: LanguageRepository

    init(repository: LanguageRepository = UserDefaultsLanguageRepository()) {
        self.repository = repository
        supportedLanguages = repository.fetchSupportedLanguages()
        currentLanguage = repository.fetchSelectedLanguage()
    }

    func select(language: AppLanguage) {
        guard language != currentLanguage else { return }
        currentLanguage = language
        repository.saveSelectedLanguage(language)
    }

    func text(_ key: AppLocalizationKey, _ arguments: CVarArg...) -> String {
        let format = localizedFormat(for: key)
        guard !arguments.isEmpty else { return format }

        return String(format: format, locale: currentLanguage.locale, arguments: arguments)
    }

    private func localizedFormat(for key: AppLocalizationKey) -> String {
        switch (currentLanguage, key) {
        case (.english, .appName): "Study"
        case (.english, .commonSearch): "Search"
        case (.english, .commonOk): "OK"
        case (.english, .commonComingSoon): "Coming soon"
        case (.english, .launchTitle): "Hello and\nwelcome here!"
        case (.english, .launchSubtitle): "Get an overview of how you are performing\nand motivate yourself to achieve even more!"
        case (.english, .launchStartButton): "Let's Start"
        case (.english, .launchLanguageLabel): "Language"
        case (.english, .chooseLanguageTitle): "Choose your language"
        case (.english, .chooseLanguageDescription): "Select the app language to apply it across the full experience."
        case (.english, .settingsTitle): "Settings"
        case (.english, .settingsAppLanguage): "App language"
        case (.english, .settingsNotifications): "Notifications"
        case (.english, .settingsUpdateVersion): "Update version"
        case (.english, .settingsWelcome): "Welcome"
        case (.english, .settingsPrivacyPolicy): "Privacy Policy"
        case (.english, .settingsTerms): "Terms"
        case (.english, .settingsLogoutTitle): "Log out?"
        case (.english, .settingsLogoutMessage): "Do you want to log out from this account?"
        case (.english, .settingsLogoutYes): "Yes"
        case (.english, .settingsLogoutNo): "No"
        case (.english, .settingsLoggingOutTitle): "Logging Out"
        case (.english, .settingsLoggingOutMessage): "Closing your session and clearing secure account data."
        case (.english, .settingsLoggedOutTitle): "Logged Out"
        case (.english, .settingsLogoutFailedTitle): "Logout Failed"
        case (.english, .aboutTitle): "About"
        case (.english, .aboutUs): "About Us"
        case (.english, .help): "Help"
        case (.english, .termsAndConditions): "Terms and Conditions"
        case (.english, .dataPolicy): "Data Policy"
        case (.english, .dashboardGreeting): "Hi, %@"
        case (.english, .dashboardLoading): "Loading..."
        case (.english, .dashboardFailedToLoad): "Failed to load data"
        case (.english, .dashboardPresence): "Presence"
        case (.english, .dashboardCompleteness): "Completeness"
        case (.english, .dashboardAssignments): "Assignments"
        case (.english, .dashboardTotalSubjects): "Total Subjects"
        case (.english, .dashboardSchedule): "Schedule"
        case (.english, .dashboardCourse): "Course"
        case (.english, .dashboardSubjects): "Subjects"
        case (.english, .dashboardClass): "Class"
        case (.english, .dashboardCalendar): "Calendar"
        case (.english, .dashboardProfile): "Profile"
        case (.english, .authSignIn): "Sign In"
        case (.english, .authSignUp): "Sign Up"
        case (.english, .authForgotPassword): "Forgot Password"
        case (.english, .authForgotPasswordDescription): "Enter your registered email id to reset your password."
        case (.english, .authVerifyEmail): "Verify Email"
        case (.english, .authEmailVerifiedTitle): "Email Successfully Verified"
        case (.english, .authCheckYourEmail): "If this email is registered, a verification code has been sent."
        case (.english, .authSigningInTitle): "Signing In"
        case (.english, .authSigningInMessage): "Verifying your credentials and preparing your account."
        case (.english, .authSignInFailed): "Sign In Failed"
        case (.english, .authSignedInTitle): "Signed in"
        case (.english, .authSignedInMessage): "Your account has been connected successfully."
        case (.english, .authDontHaveAccount): "Don’t have an account?"
        case (.english, .authOr): "OR"
        case (.english, .authEmail): "Email"
        case (.english, .authPassword): "Password"
        case (.english, .authPasswordPlaceholder): "Your password"
        case (.english, .authName): "Name"
        case (.english, .authNamePlaceholder): "Your name"
        case (.english, .authFirstName): "First Name"
        case (.english, .authFirstNamePlaceholder): "Your first name"
        case (.english, .authLastName): "Last Name"
        case (.english, .authLastNamePlaceholder): "Your last name"
        case (.english, .authCountryCode): "Country Code"
        case (.english, .authCountryCodePlaceholder): "+91"
        case (.english, .authContactNumber): "Phone Number"
        case (.english, .authContactNumberPlaceholder): "9876543210"
        case (.english, .authConfirmPassword): "Confirm Password"
        case (.english, .authConfirmPasswordPlaceholder): "Re-enter your password"
        case (.english, .authPhoneNumber): "Phone Number"
        case (.english, .authPhonePlaceholder): "0334 xxxx xxxx"
        case (.english, .authAgreeTermsPrefix): "I agree with the"
        case (.english, .authAgreeTermsLink): " terms and conditions"
        case (.english, .authAgreeTermsSuffix): " and also the protection of my personal data on this application"
        case (.english, .authCreatingAccountTitle): "Creating Account"
        case (.english, .authCreatingAccountMessage): "Saving your details and setting up your student profile."
        case (.english, .authAccountCreatedTitle): "Account created"
        case (.english, .authAccountCreatedMessage): "Your account is ready. Sign in with the credentials you just created."
        case (.english, .authSignUpFailed): "Sign Up Failed"
        case (.english, .authVerifyCodeTitle): "Verification Code"
        case (.english, .authVerifyCodeDescription): "Enter the code sent by SMS to verify your phone number"
        case (.english, .authVerify): "Verify"
        case (.english, .authResendCode): "Resend Code"
        case (.english, .authInvalidEmail): "Please enter a valid email"
        case (.english, .authEmptyName): "Name cannot be empty"
        case (.english, .authEmptyFirstName): "First name cannot be empty"
        case (.english, .authEmptyLastName): "Last name cannot be empty"
        case (.english, .authInvalidPhone): "Please enter a valid phone number"
        case (.english, .authInvalidCountryCode): "Enter a valid country code (e.g. +91)"
        case (.english, .authInvalidContactNumber): "Enter a valid phone number (7–15 digits)"
        case (.english, .authConfirmPasswordMismatch): "Passwords do not match"
        case (.english, .authTermsRequired): "You must agree to the terms"
        case (.english, .authEmptyPassword): "Password cannot be empty"
        case (.english, .authPasswordShort): "Password must be at least 8 characters"
        case (.english, .authPasswordWeak): "Password must contain both letters and numbers"
        case (.english, .onboardingTitleOne): "Find Your Favourite Class"
        case (.english, .onboardingDescriptionOne): "Find your favorite class. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        case (.english, .onboardingTitleTwo): "Explore More Skills"
        case (.english, .onboardingDescriptionTwo): "Learn from the best instructors and enhance your skills."
        case (.english, .onboardingTitleThree): "Get the Best Class with Best Teacher"
        case (.english, .onboardingDescriptionThree): "Accelerate your learning journey and achieve your goals."
        case (.english, .onboardingSkip): "Skip"
        case (.english, .onboardingNext): "Next"
        case (.english, .onboardingCurrentPage): "Current Page"
        case (.english, .onboardingPage): "Page"
        case (.english, .notificationTitle): "Notifications"
        case (.english, .notificationEmail): "Email Notification"
        case (.english, .notificationEmailSubtitle): "Enable or disable email notification"
        case (.english, .notificationUpdates): "App Updates"
        case (.english, .notificationUpdatesSubtitle): "Enable automatic app updates"
        case (.english, .notificationRecommendations): "Recommendations"
        case (.english, .notificationRecommendationsSubtitle): "Receive suggestions and invitations"
        case (.english, .notificationMessages): "Messages"
        case (.english, .notificationMessagesSubtitle): "Enable message notifications"

        case (.hindi, .appName): "स्टडी"
        case (.hindi, .commonSearch): "खोजें"
        case (.hindi, .commonOk): "ठीक है"
        case (.hindi, .commonComingSoon): "जल्द आ रहा है"
        case (.hindi, .launchTitle): "नमस्ते और\nआपका स्वागत है!"
        case (.hindi, .launchSubtitle): "देखें कि आप कैसा प्रदर्शन कर रहे हैं\nऔर खुद को और बेहतर करने के लिए प्रेरित करें!"
        case (.hindi, .launchStartButton): "शुरू करें"
        case (.hindi, .launchLanguageLabel): "भाषा"
        case (.hindi, .chooseLanguageTitle): "अपनी भाषा चुनें"
        case (.hindi, .chooseLanguageDescription): "पूरे ऐप में लागू करने के लिए अपनी पसंदीदा भाषा चुनें।"
        case (.hindi, .settingsTitle): "सेटिंग्स"
        case (.hindi, .settingsAppLanguage): "ऐप भाषा"
        case (.hindi, .settingsNotifications): "सूचनाएँ"
        case (.hindi, .settingsUpdateVersion): "संस्करण अपडेट"
        case (.hindi, .settingsWelcome): "स्वागत है"
        case (.hindi, .settingsPrivacyPolicy): "गोपनीयता नीति"
        case (.hindi, .settingsTerms): "नियम"
        case (.hindi, .settingsLogoutTitle): "लॉग आउट करें?"
        case (.hindi, .settingsLogoutMessage): "क्या आप इस खाते से लॉग आउट करना चाहते हैं?"
        case (.hindi, .settingsLogoutYes): "हाँ"
        case (.hindi, .settingsLogoutNo): "नहीं"
        case (.hindi, .settingsLoggingOutTitle): "लॉग आउट हो रहा है"
        case (.hindi, .settingsLoggingOutMessage): "आपका सत्र बंद किया जा रहा है और सुरक्षित खाता डेटा साफ किया जा रहा है।"
        case (.hindi, .settingsLoggedOutTitle): "लॉग आउट हो गया"
        case (.hindi, .settingsLogoutFailedTitle): "लॉग आउट असफल"
        case (.hindi, .aboutTitle): "जानकारी"
        case (.hindi, .aboutUs): "हमारे बारे में"
        case (.hindi, .help): "सहायता"
        case (.hindi, .termsAndConditions): "नियम और शर्तें"
        case (.hindi, .dataPolicy): "डेटा नीति"
        case (.hindi, .dashboardGreeting): "नमस्ते, %@"
        case (.hindi, .dashboardLoading): "लोड हो रहा है..."
        case (.hindi, .dashboardFailedToLoad): "डेटा लोड नहीं हो सका"
        case (.hindi, .dashboardPresence): "उपस्थिति"
        case (.hindi, .dashboardCompleteness): "पूर्णता"
        case (.hindi, .dashboardAssignments): "असाइनमेंट"
        case (.hindi, .dashboardTotalSubjects): "कुल विषय"
        case (.hindi, .dashboardSchedule): "समय-सारणी"
        case (.hindi, .dashboardCourse): "कोर्स"
        case (.hindi, .dashboardSubjects): "विषय"
        case (.hindi, .dashboardClass): "कक्षा"
        case (.hindi, .dashboardCalendar): "कैलेंडर"
        case (.hindi, .dashboardProfile): "प्रोफ़ाइल"
        case (.hindi, .authSignIn): "साइन इन"
        case (.hindi, .authSignUp): "साइन अप"
        case (.hindi, .authForgotPassword): "पासवर्ड भूल गए"
        case (.hindi, .authForgotPasswordDescription): "पासवर्ड रीसेट करने के लिए अपना पंजीकृत ईमेल दर्ज करें।"
        case (.hindi, .authVerifyEmail): "ईमेल सत्यापित करें"
        case (.hindi, .authEmailVerifiedTitle): "ईमेल सफलतापूर्वक सत्यापित हुआ"
        case (.hindi, .authCheckYourEmail): "यदि यह ईमेल पंजीकृत है, तो एक सत्यापन कोड भेज दिया गया है।"
        case (.hindi, .authSigningInTitle): "साइन इन हो रहा है"
        case (.hindi, .authSigningInMessage): "आपकी जानकारी सत्यापित की जा रही है और आपका खाता तैयार किया जा रहा है।"
        case (.hindi, .authSignInFailed): "साइन इन असफल"
        case (.hindi, .authSignedInTitle): "साइन इन सफल"
        case (.hindi, .authSignedInMessage): "आपका खाता सफलतापूर्वक जोड़ा गया है।"
        case (.hindi, .authDontHaveAccount): "क्या आपका खाता नहीं है?"
        case (.hindi, .authOr): "या"
        case (.hindi, .authEmail): "ईमेल"
        case (.hindi, .authPassword): "पासवर्ड"
        case (.hindi, .authPasswordPlaceholder): "अपना पासवर्ड"
        case (.hindi, .authName): "नाम"
        case (.hindi, .authNamePlaceholder): "आपका नाम"
        case (.hindi, .authFirstName): "पहला नाम"
        case (.hindi, .authFirstNamePlaceholder): "आपका पहला नाम"
        case (.hindi, .authLastName): "अंतिम नाम"
        case (.hindi, .authLastNamePlaceholder): "आपका अंतिम नाम"
        case (.hindi, .authCountryCode): "देश कोड"
        case (.hindi, .authCountryCodePlaceholder): "+91"
        case (.hindi, .authContactNumber): "फ़ोन नंबर"
        case (.hindi, .authContactNumberPlaceholder): "9876543210"
        case (.hindi, .authConfirmPassword): "पासवर्ड की पुष्टि"
        case (.hindi, .authConfirmPasswordPlaceholder): "पासवर्ड दोबारा दर्ज करें"
        case (.hindi, .authPhoneNumber): "फ़ोन नंबर"
        case (.hindi, .authPhonePlaceholder): "0334 xxxx xxxx"
        case (.hindi, .authAgreeTermsPrefix): "मैं"
        case (.hindi, .authAgreeTermsLink): " नियम और शर्तों"
        case (.hindi, .authAgreeTermsSuffix): " तथा इस ऐप पर मेरे व्यक्तिगत डेटा की सुरक्षा से सहमत हूँ"
        case (.hindi, .authCreatingAccountTitle): "खाता बनाया जा रहा है"
        case (.hindi, .authCreatingAccountMessage): "आपकी जानकारी सहेजी जा रही है और छात्र प्रोफ़ाइल तैयार की जा रही है।"
        case (.hindi, .authAccountCreatedTitle): "खाता बन गया"
        case (.hindi, .authAccountCreatedMessage): "आपका खाता तैयार है। अभी बनाए गए विवरण से साइन इन करें।"
        case (.hindi, .authSignUpFailed): "साइन अप असफल"
        case (.hindi, .authVerifyCodeTitle): "सत्यापन कोड"
        case (.hindi, .authVerifyCodeDescription): "अपने फ़ोन नंबर की पुष्टि के लिए SMS में भेजा गया कोड दर्ज करें"
        case (.hindi, .authVerify): "सत्यापित करें"
        case (.hindi, .authResendCode): "कोड फिर भेजें"
        case (.hindi, .authInvalidEmail): "कृपया मान्य ईमेल दर्ज करें"
        case (.hindi, .authEmptyName): "नाम खाली नहीं हो सकता"
        case (.hindi, .authEmptyFirstName): "पहला नाम खाली नहीं हो सकता"
        case (.hindi, .authEmptyLastName): "अंतिम नाम खाली नहीं हो सकता"
        case (.hindi, .authInvalidPhone): "कृपया मान्य फ़ोन नंबर दर्ज करें"
        case (.hindi, .authInvalidCountryCode): "मान्य देश कोड दर्ज करें (जैसे +91)"
        case (.hindi, .authInvalidContactNumber): "मान्य फ़ोन नंबर दर्ज करें (7–15 अंक)"
        case (.hindi, .authConfirmPasswordMismatch): "पासवर्ड मेल नहीं खाते"
        case (.hindi, .authTermsRequired): "आपको नियमों से सहमत होना होगा"
        case (.hindi, .authEmptyPassword): "पासवर्ड खाली नहीं हो सकता"
        case (.hindi, .authPasswordShort): "पासवर्ड कम से कम 8 अक्षरों का होना चाहिए"
        case (.hindi, .authPasswordWeak): "पासवर्ड में अक्षर और अंक दोनों होने चाहिए"
        case (.hindi, .onboardingTitleOne): "अपनी पसंदीदा कक्षा खोजें"
        case (.hindi, .onboardingDescriptionOne): "अपनी पसंदीदा कक्षा खोजें और सीखने की सही शुरुआत करें।"
        case (.hindi, .onboardingTitleTwo): "और कौशल सीखें"
        case (.hindi, .onboardingDescriptionTwo): "श्रेष्ठ शिक्षकों से सीखें और अपने कौशल को बेहतर बनाएं।"
        case (.hindi, .onboardingTitleThree): "श्रेष्ठ शिक्षक के साथ श्रेष्ठ कक्षा पाएं"
        case (.hindi, .onboardingDescriptionThree): "अपनी सीखने की यात्रा को तेज करें और अपने लक्ष्य हासिल करें।"
        case (.hindi, .onboardingSkip): "छोड़ें"
        case (.hindi, .onboardingNext): "अगला"
        case (.hindi, .onboardingCurrentPage): "वर्तमान पृष्ठ"
        case (.hindi, .onboardingPage): "पृष्ठ"
        case (.hindi, .notificationTitle): "सूचनाएँ"
        case (.hindi, .notificationEmail): "ईमेल सूचनाएँ"
        case (.hindi, .notificationEmailSubtitle): "ईमेल सूचनाएँ चालू या बंद करें"
        case (.hindi, .notificationUpdates): "ऐप अपडेट"
        case (.hindi, .notificationUpdatesSubtitle): "स्वचालित ऐप अपडेट सक्षम करें"
        case (.hindi, .notificationRecommendations): "सुझाव"
        case (.hindi, .notificationRecommendationsSubtitle): "सुझाव और निमंत्रण प्राप्त करें"
        case (.hindi, .notificationMessages): "संदेश"
        case (.hindi, .notificationMessagesSubtitle): "संदेश सूचनाएँ सक्षम करें"
        }
    }
}

@MainActor
final class LanguageViewModel: ObservableObject {
    @Published var searchText = ""
    @Published private(set) var languages: [AppLanguage] = []
    @Published private(set) var selectedLanguage: AppLanguage = .english

    private weak var localizationService: LocalizationService?

    var filteredLanguages: [AppLanguage] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return languages }

        return languages.filter {
            $0.nativeName.localizedCaseInsensitiveContains(query) ||
            $0.accessibilityName.localizedCaseInsensitiveContains(query)
        }
    }

    func configure(with localizationService: LocalizationService) {
        self.localizationService = localizationService
        languages = localizationService.supportedLanguages
        selectedLanguage = localizationService.currentLanguage
    }

    func select(language: AppLanguage) {
        localizationService?.select(language: language)
        selectedLanguage = language
    }
}
