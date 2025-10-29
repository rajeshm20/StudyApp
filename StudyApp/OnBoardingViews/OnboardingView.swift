//
//  OnboardingView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 28/09/24.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Properties

    private let pages: [PageData] = [
        PageData(imageName: "StudyingFemale",
                 title: NSLocalizedString("Find Your Favourite Class", comment: "Onboarding title 1"),
                 description: NSLocalizedString("Find your favorite class. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", comment: "Onboarding description 1")),
        PageData(imageName: "student3",
                 title: NSLocalizedString("Explore More Skills", comment: "Onboarding title 2"),
                 description: NSLocalizedString("Learn from the best instructors and enhance your skills.", comment: "Onboarding description 2")),
        PageData(imageName: "student5",
                 title: NSLocalizedString("Get the Best Class with Best Teacher", comment: "Onboarding title 3"),
                 description: NSLocalizedString("Accelerate your learning journey and achieve your goals.", comment: "Onboarding description 3"))
    ]

    @State private var currentPage = 0
    @ObservedObject var router: Router<AuthRoute>

    // MARK: - Main View

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { (index, page) in
                        OnboardingPageView(page: page)
                            .tag(index)
                            .accessibilityElement(children: .ignore)
                    }
                }
                .ignoresSafeArea(.container, edges: .top)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: geo.size.height * 0.8)

                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.cyan : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .accessibilityLabel(
                                Text(currentPage == index
                                     ? NSLocalizedString("Current Page", comment: "")
                                     : NSLocalizedString("Page", comment: ""))
                            )
                    }
                }
                .padding(.top, 8)

                Spacer()

                // Navigation Buttons
                HStack {
                    Button(action: handleSkipOrSignUp) {
                        Text(currentPage == pages.count - 1
                             ? NSLocalizedString("Sign Up", comment: "Sign Up button")
                             : NSLocalizedString("Skip", comment: "Skip button"))
                            .font(.headline)
                            .foregroundColor(.cyan)
                    }
                    .accessibilityLabel(Text(currentPage == pages.count - 1 ? "Sign Up" : "Skip"))
                    
                    Spacer()

                    Button(action: handleRightButton) {
                        if currentPage == pages.count - 1 {
                            Text(NSLocalizedString("Sign In", comment: "Sign In button"))
                                .font(.headline)
                                .foregroundColor(.cyan)
                        } else {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.cyan)
                                .clipShape(Circle())
                                .accessibilityLabel(Text(NSLocalizedString("Next", comment: "Next page")))
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, geo.safeAreaInsets.bottom + 30)
                .navigationBarBackButtonHidden(true)
            }
            .background(Color.white.ignoresSafeArea())
        }
    }

    // MARK: - Actions

    private func handleSkipOrSignUp() {
        if currentPage == pages.count - 1 {
            router.push(.signUp)
        } else {
            // Jump to last page
            currentPage = pages.count - 1
        }
    }

    private func handleRightButton() {
        if currentPage == pages.count - 1 {
            router.push(.signIn)
        } else if currentPage < pages.count - 1 {
            currentPage += 1
        }
    }
}

// MARK: - OnboardingPageView

struct OnboardingPageView: View {
    let page: PageData

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    Group {
                        if let uiImage = UIImage(named: page.imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            // Fallback placeholder for missing images
                            Color.gray.opacity(0.2)
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.6 + geo.safeAreaInsets.top)
                    .clipped()
                    .accessibilityLabel(Text(page.title))

                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .cyan.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: geo.size.width, height: geo.size.height * 0.6 + geo.safeAreaInsets.top)
                    .allowsHitTesting(false)
                    
                    // Title Icon
                    TopIcon_Title(title: "Study")
                        .padding(.top, geo.safeAreaInsets.top + 32)
                        .padding(.leading, 20)
                        .accessibilityHidden(true)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.6 + geo.safeAreaInsets.top)
                .contentShape(Rectangle())
                .clipped()
                .ignoresSafeArea(.container, edges: .top)

                VStack(spacing: 20) {
                    Text(page.title)
                        .font(.system(size: 25, weight: .bold))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 24)
                        .accessibilityAddTraits(.isHeader)

                    Text(page.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                .accessibilityElement(children: .combine)

                Spacer(minLength: 0)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 15 Pro", "iPhone SE (3rd generation)"], id: \.self) { device in
            OnboardingView(router: Router<AuthRoute>())
                .previewDevice(PreviewDevice(rawValue: device))
                .environmentObject(AppCoordinator())
                .previewDisplayName(device)
        }
    }
}
