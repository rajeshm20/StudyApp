import Foundation
#if canImport(AppKit)
    import AppKit
#endif
#if canImport(UIKit)
    import UIKit
#endif
#if canImport(SwiftUI)
    import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
    import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
    private let resourceBundle = Foundation.Bundle.module
#else
    private class ResourceBundleClass {}
    private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {
    /// The "AccentColor" asset catalog color resource.
    static let accent = DeveloperToolsSupport.ColorResource(name: "AccentColor", bundle: resourceBundle)

    /// The "AppBackground" asset catalog color resource.
    static let appBackground = DeveloperToolsSupport.ColorResource(name: "AppBackground", bundle: resourceBundle)

    /// The "AppTextPrimary" asset catalog color resource.
    static let appTextPrimary = DeveloperToolsSupport.ColorResource(name: "AppTextPrimary", bundle: resourceBundle)

    /// The "BackgroundColor" asset catalog color resource.
    static let background = DeveloperToolsSupport.ColorResource(name: "BackgroundColor", bundle: resourceBundle)

    /// The "BorderColor" asset catalog color resource.
    static let border = DeveloperToolsSupport.ColorResource(name: "BorderColor", bundle: resourceBundle)

    /// The "Color" asset catalog color resource.
    static let color = DeveloperToolsSupport.ColorResource(name: "Color", bundle: resourceBundle)

    /// The "PrimaryColor" asset catalog color resource.
    static let primary = DeveloperToolsSupport.ColorResource(name: "PrimaryColor", bundle: resourceBundle)

    /// The "TextPrimary" asset catalog color resource.
    static let textPrimary = DeveloperToolsSupport.ColorResource(name: "TextPrimary", bundle: resourceBundle)

    /// The "TextSecondary" asset catalog color resource.
    static let textSecondary = DeveloperToolsSupport.ColorResource(name: "TextSecondary", bundle: resourceBundle)

    /// The "buttoncolor" asset catalog color resource.
    static let buttoncolor = DeveloperToolsSupport.ColorResource(name: "buttoncolor", bundle: resourceBundle)

    /// The "themeColor" asset catalog color resource.
    static let theme = DeveloperToolsSupport.ColorResource(name: "themeColor", bundle: resourceBundle)
}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {
    /// The "StudyingFemale" asset catalog image resource.
    static let studyingFemale = DeveloperToolsSupport.ImageResource(name: "StudyingFemale", bundle: resourceBundle)

    /// The "SucessTick" asset catalog image resource.
    static let sucessTick = DeveloperToolsSupport.ImageResource(name: "SucessTick", bundle: resourceBundle)

    /// The "apple" asset catalog image resource.
    static let apple = DeveloperToolsSupport.ImageResource(name: "apple", bundle: resourceBundle)

    /// The "chung" asset catalog image resource.
    static let chung = DeveloperToolsSupport.ImageResource(name: "chung", bundle: resourceBundle)

    /// The "facebook" asset catalog image resource.
    static let facebook = DeveloperToolsSupport.ImageResource(name: "facebook", bundle: resourceBundle)

    /// The "google" asset catalog image resource.
    static let google = DeveloperToolsSupport.ImageResource(name: "google", bundle: resourceBundle)

    /// The "key" asset catalog image resource.
    static let key = DeveloperToolsSupport.ImageResource(name: "key", bundle: resourceBundle)

    /// The "mobilefemale" asset catalog image resource.
    static let mobilefemale = DeveloperToolsSupport.ImageResource(name: "mobilefemale", bundle: resourceBundle)

    /// The "smilingFemale1" asset catalog image resource.
    static let smilingFemale1 = DeveloperToolsSupport.ImageResource(name: "smilingFemale1", bundle: resourceBundle)

    /// The "smilingFemale2" asset catalog image resource.
    static let smilingFemale2 = DeveloperToolsSupport.ImageResource(name: "smilingFemale2", bundle: resourceBundle)

    /// The "smilyBlack" asset catalog image resource.
    static let smilyBlack = DeveloperToolsSupport.ImageResource(name: "smilyBlack", bundle: resourceBundle)

    /// The "standingFemale" asset catalog image resource.
    static let standingFemale = DeveloperToolsSupport.ImageResource(name: "standingFemale", bundle: resourceBundle)

    /// The "student2" asset catalog image resource.
    static let student2 = DeveloperToolsSupport.ImageResource(name: "student2", bundle: resourceBundle)

    /// The "student3" asset catalog image resource.
    static let student3 = DeveloperToolsSupport.ImageResource(name: "student3", bundle: resourceBundle)

    /// The "student5" asset catalog image resource.
    static let student5 = DeveloperToolsSupport.ImageResource(name: "student5", bundle: resourceBundle)

    /// The "studyFemale1" asset catalog image resource.
    static let studyFemale1 = DeveloperToolsSupport.ImageResource(name: "studyFemale1", bundle: resourceBundle)

    /// The "thumbsUp" asset catalog image resource.
    static let thumbsUp = DeveloperToolsSupport.ImageResource(name: "thumbsUp", bundle: resourceBundle)

    /// The "zenchung" asset catalog image resource.
    static let zenchung = DeveloperToolsSupport.ImageResource(name: "zenchung", bundle: resourceBundle)
}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
    @available(macOS 14.0, *)
    @available(macCatalyst, unavailable)
    extension AppKit.NSColor {
        /// The "AccentColor" asset catalog color.
        static var accent: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .accent)
            #else
                .init()
            #endif
        }

        /// The "AppBackground" asset catalog color.
        static var appBackground: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .appBackground)
            #else
                .init()
            #endif
        }

        /// The "AppTextPrimary" asset catalog color.
        static var appTextPrimary: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .appTextPrimary)
            #else
                .init()
            #endif
        }

        /// The "BackgroundColor" asset catalog color.
        static var background: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .background)
            #else
                .init()
            #endif
        }

        /// The "BorderColor" asset catalog color.
        static var border: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .border)
            #else
                .init()
            #endif
        }

        /// The "Color" asset catalog color.
        static var color: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .color)
            #else
                .init()
            #endif
        }

        /// The "PrimaryColor" asset catalog color.
        static var primary: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .primary)
            #else
                .init()
            #endif
        }

        /// The "TextPrimary" asset catalog color.
        static var textPrimary: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .textPrimary)
            #else
                .init()
            #endif
        }

        /// The "TextSecondary" asset catalog color.
        static var textSecondary: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .textSecondary)
            #else
                .init()
            #endif
        }

        /// The "buttoncolor" asset catalog color.
        static var buttoncolor: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .buttoncolor)
            #else
                .init()
            #endif
        }

        /// The "themeColor" asset catalog color.
        static var theme: AppKit.NSColor {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .theme)
            #else
                .init()
            #endif
        }
    }
#endif

#if canImport(UIKit)
    @available(iOS 17.0, tvOS 17.0, *)
    @available(watchOS, unavailable)
    extension UIKit.UIColor {
        /// The "AccentColor" asset catalog color.
        static var accent: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .accent)
            #else
                .init()
            #endif
        }

        /// The "AppBackground" asset catalog color.
        static var appBackground: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .appBackground)
            #else
                .init()
            #endif
        }

        /// The "AppTextPrimary" asset catalog color.
        static var appTextPrimary: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .appTextPrimary)
            #else
                .init()
            #endif
        }

        /// The "BackgroundColor" asset catalog color.
        static var background: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .background)
            #else
                .init()
            #endif
        }

        /// The "BorderColor" asset catalog color.
        static var border: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .border)
            #else
                .init()
            #endif
        }

        /// The "Color" asset catalog color.
        static var color: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .color)
            #else
                .init()
            #endif
        }

        /// The "PrimaryColor" asset catalog color.
        static var primary: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .primary)
            #else
                .init()
            #endif
        }

        /// The "TextPrimary" asset catalog color.
        static var textPrimary: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .textPrimary)
            #else
                .init()
            #endif
        }

        /// The "TextSecondary" asset catalog color.
        static var textSecondary: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .textSecondary)
            #else
                .init()
            #endif
        }

        /// The "buttoncolor" asset catalog color.
        static var buttoncolor: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .buttoncolor)
            #else
                .init()
            #endif
        }

        /// The "themeColor" asset catalog color.
        static var theme: UIKit.UIColor {
            #if !os(watchOS)
                .init(resource: .theme)
            #else
                .init()
            #endif
        }
    }
#endif

#if canImport(SwiftUI)
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    extension SwiftUI.Color {
        /// The "AccentColor" asset catalog color.
        static var accent: SwiftUI.Color { .init(.accent) }

        /// The "AppBackground" asset catalog color.
        static var appBackground: SwiftUI.Color { .init(.appBackground) }

        /// The "AppTextPrimary" asset catalog color.
        static var appTextPrimary: SwiftUI.Color { .init(.appTextPrimary) }

        /// The "BackgroundColor" asset catalog color.
        static var background: SwiftUI.Color { .init(.background) }

        /// The "BorderColor" asset catalog color.
        static var border: SwiftUI.Color { .init(.border) }

        /// The "Color" asset catalog color.
        static var color: SwiftUI.Color { .init(.color) }

        #warning("The \"PrimaryColor\" color asset name resolves to a conflicting Color symbol \"primary\". Try renaming the asset.")

        /// The "TextPrimary" asset catalog color.
        static var textPrimary: SwiftUI.Color { .init(.textPrimary) }

        /// The "TextSecondary" asset catalog color.
        static var textSecondary: SwiftUI.Color { .init(.textSecondary) }

        /// The "buttoncolor" asset catalog color.
        static var buttoncolor: SwiftUI.Color { .init(.buttoncolor) }

        /// The "themeColor" asset catalog color.
        static var theme: SwiftUI.Color { .init(.theme) }
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {
        /// The "AccentColor" asset catalog color.
        static var accent: SwiftUI.Color { .init(.accent) }

        /// The "AppBackground" asset catalog color.
        static var appBackground: SwiftUI.Color { .init(.appBackground) }

        /// The "AppTextPrimary" asset catalog color.
        static var appTextPrimary: SwiftUI.Color { .init(.appTextPrimary) }

        /// The "BackgroundColor" asset catalog color.
        static var background: SwiftUI.Color { .init(.background) }

        /// The "BorderColor" asset catalog color.
        static var border: SwiftUI.Color { .init(.border) }

        /// The "Color" asset catalog color.
        static var color: SwiftUI.Color { .init(.color) }

        /// The "TextPrimary" asset catalog color.
        static var textPrimary: SwiftUI.Color { .init(.textPrimary) }

        /// The "TextSecondary" asset catalog color.
        static var textSecondary: SwiftUI.Color { .init(.textSecondary) }

        /// The "buttoncolor" asset catalog color.
        static var buttoncolor: SwiftUI.Color { .init(.buttoncolor) }

        /// The "themeColor" asset catalog color.
        static var theme: SwiftUI.Color { .init(.theme) }
    }
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
    @available(macOS 14.0, *)
    @available(macCatalyst, unavailable)
    extension AppKit.NSImage {
        /// The "StudyingFemale" asset catalog image.
        static var studyingFemale: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .studyingFemale)
            #else
                .init()
            #endif
        }

        /// The "SucessTick" asset catalog image.
        static var sucessTick: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .sucessTick)
            #else
                .init()
            #endif
        }

        /// The "apple" asset catalog image.
        static var apple: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .apple)
            #else
                .init()
            #endif
        }

        /// The "chung" asset catalog image.
        static var chung: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .chung)
            #else
                .init()
            #endif
        }

        /// The "facebook" asset catalog image.
        static var facebook: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .facebook)
            #else
                .init()
            #endif
        }

        /// The "google" asset catalog image.
        static var google: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .google)
            #else
                .init()
            #endif
        }

        /// The "key" asset catalog image.
        static var key: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .key)
            #else
                .init()
            #endif
        }

        /// The "mobilefemale" asset catalog image.
        static var mobilefemale: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .mobilefemale)
            #else
                .init()
            #endif
        }

        /// The "smilingFemale1" asset catalog image.
        static var smilingFemale1: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .smilingFemale1)
            #else
                .init()
            #endif
        }

        /// The "smilingFemale2" asset catalog image.
        static var smilingFemale2: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .smilingFemale2)
            #else
                .init()
            #endif
        }

        /// The "smilyBlack" asset catalog image.
        static var smilyBlack: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .smilyBlack)
            #else
                .init()
            #endif
        }

        /// The "standingFemale" asset catalog image.
        static var standingFemale: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .standingFemale)
            #else
                .init()
            #endif
        }

        /// The "student2" asset catalog image.
        static var student2: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .student2)
            #else
                .init()
            #endif
        }

        /// The "student3" asset catalog image.
        static var student3: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .student3)
            #else
                .init()
            #endif
        }

        /// The "student5" asset catalog image.
        static var student5: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .student5)
            #else
                .init()
            #endif
        }

        /// The "studyFemale1" asset catalog image.
        static var studyFemale1: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .studyFemale1)
            #else
                .init()
            #endif
        }

        /// The "thumbsUp" asset catalog image.
        static var thumbsUp: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .thumbsUp)
            #else
                .init()
            #endif
        }

        /// The "zenchung" asset catalog image.
        static var zenchung: AppKit.NSImage {
            #if !targetEnvironment(macCatalyst)
                .init(resource: .zenchung)
            #else
                .init()
            #endif
        }
    }
#endif

#if canImport(UIKit)
    @available(iOS 17.0, tvOS 17.0, *)
    @available(watchOS, unavailable)
    extension UIKit.UIImage {
        /// The "StudyingFemale" asset catalog image.
        static var studyingFemale: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .studyingFemale)
            #else
                .init()
            #endif
        }

        /// The "SucessTick" asset catalog image.
        static var sucessTick: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .sucessTick)
            #else
                .init()
            #endif
        }

        /// The "apple" asset catalog image.
        static var apple: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .apple)
            #else
                .init()
            #endif
        }

        /// The "chung" asset catalog image.
        static var chung: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .chung)
            #else
                .init()
            #endif
        }

        /// The "facebook" asset catalog image.
        static var facebook: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .facebook)
            #else
                .init()
            #endif
        }

        /// The "google" asset catalog image.
        static var google: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .google)
            #else
                .init()
            #endif
        }

        /// The "key" asset catalog image.
        static var key: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .key)
            #else
                .init()
            #endif
        }

        /// The "mobilefemale" asset catalog image.
        static var mobilefemale: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .mobilefemale)
            #else
                .init()
            #endif
        }

        /// The "smilingFemale1" asset catalog image.
        static var smilingFemale1: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .smilingFemale1)
            #else
                .init()
            #endif
        }

        /// The "smilingFemale2" asset catalog image.
        static var smilingFemale2: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .smilingFemale2)
            #else
                .init()
            #endif
        }

        /// The "smilyBlack" asset catalog image.
        static var smilyBlack: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .smilyBlack)
            #else
                .init()
            #endif
        }

        /// The "standingFemale" asset catalog image.
        static var standingFemale: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .standingFemale)
            #else
                .init()
            #endif
        }

        /// The "student2" asset catalog image.
        static var student2: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .student2)
            #else
                .init()
            #endif
        }

        /// The "student3" asset catalog image.
        static var student3: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .student3)
            #else
                .init()
            #endif
        }

        /// The "student5" asset catalog image.
        static var student5: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .student5)
            #else
                .init()
            #endif
        }

        /// The "studyFemale1" asset catalog image.
        static var studyFemale1: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .studyFemale1)
            #else
                .init()
            #endif
        }

        /// The "thumbsUp" asset catalog image.
        static var thumbsUp: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .thumbsUp)
            #else
                .init()
            #endif
        }

        /// The "zenchung" asset catalog image.
        static var zenchung: UIKit.UIImage {
            #if !os(watchOS)
                .init(resource: .zenchung)
            #else
                .init()
            #endif
        }
    }
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {
    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
        #if canImport(AppKit) && os(macOS)
            if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
                self.init(name: thinnableName, bundle: bundle)
            } else {
                return nil
            }
        #elseif canImport(UIKit) && !os(watchOS)
            if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
                self.init(name: thinnableName, bundle: bundle)
            } else {
                return nil
            }
        #else
            return nil
        #endif
    }
}

#if canImport(AppKit)
    @available(macOS 14.0, *)
    @available(macCatalyst, unavailable)
    extension AppKit.NSColor {
        private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
            #if !targetEnvironment(macCatalyst)
                if let resource = thinnableResource {
                    self.init(resource: resource)
                } else {
                    return nil
                }
            #else
                return nil
            #endif
        }
    }
#endif

#if canImport(UIKit)
    @available(iOS 17.0, tvOS 17.0, *)
    @available(watchOS, unavailable)
    extension UIKit.UIColor {
        private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
            #if !os(watchOS)
                if let resource = thinnableResource {
                    self.init(resource: resource)
                } else {
                    return nil
                }
            #else
                return nil
            #endif
        }
    }
#endif

#if canImport(SwiftUI)
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    extension SwiftUI.Color {
        private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
            if let resource = thinnableResource {
                self.init(resource)
            } else {
                return nil
            }
        }
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {
        private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
            if let resource = thinnableResource {
                self.init(resource)
            } else {
                return nil
            }
        }
    }
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {
    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
        #if canImport(AppKit) && os(macOS)
            if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
                self.init(name: thinnableName, bundle: bundle)
            } else {
                return nil
            }
        #elseif canImport(UIKit) && !os(watchOS)
            if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
                self.init(name: thinnableName, bundle: bundle)
            } else {
                return nil
            }
        #else
            return nil
        #endif
    }
}

#if canImport(AppKit)
    @available(macOS 14.0, *)
    @available(macCatalyst, unavailable)
    extension AppKit.NSImage {
        private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
            #if !targetEnvironment(macCatalyst)
                if let resource = thinnableResource {
                    self.init(resource: resource)
                } else {
                    return nil
                }
            #else
                return nil
            #endif
        }
    }
#endif

#if canImport(UIKit)
    @available(iOS 17.0, tvOS 17.0, *)
    @available(watchOS, unavailable)
    extension UIKit.UIImage {
        private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
            #if !os(watchOS)
                if let resource = thinnableResource {
                    self.init(resource: resource)
                } else {
                    return nil
                }
            #else
                return nil
            #endif
        }
    }
#endif
