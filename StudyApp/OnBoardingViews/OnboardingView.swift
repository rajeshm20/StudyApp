//
//  OnboardingView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 28/09/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    @State private var currentPage = 0
    @ObservedObject var router: Router<AuthRoute>

    private var pages: [PageData] {
        [
            PageData(
                imageName: "StudyingFemale",
                title: localizationService.text(.onboardingTitleOne),
                description: localizationService.text(.onboardingDescriptionOne)
            ),
            PageData(
                imageName: "student3",
                title: localizationService.text(.onboardingTitleTwo),
                description: localizationService.text(.onboardingDescriptionTwo)
            ),
            PageData(
                imageName: "student5",
                title: localizationService.text(.onboardingTitleThree),
                description: localizationService.text(.onboardingDescriptionThree)
            )
        ]
    }

    private var windowTopInset: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
            let keyWindow = windowScene.windows.first(where: \.isKeyWindow)
        else {
            return 0
        }
        return keyWindow.safeAreaInsets.top
    }

    var body: some View {
        GeometryReader { geo in
            let topInset = max(windowTopInset, geo.frame(in: .global).minY)

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                            .accessibilityElement(children: .ignore)
                    }
                }
                .ignoresSafeArea(.container, edges: .top)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: geo.size.height * 0.8 + topInset)
                .padding(.top, -topInset)

                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.cyan : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .accessibilityLabel(
                                Text(currentPage == index
                                    ? localizationService.text(.onboardingCurrentPage)
                                    : localizationService.text(.onboardingPage))
                            )
                    }
                }

                Spacer()

                HStack {
                    Button(action: handleSkipOrSignUp) {
                        Text(currentPage == pages.count - 1
                            ? localizationService.text(.authSignUp)
                            : localizationService.text(.onboardingSkip))
                            .font(.headline)
                            .foregroundColor(.cyan)
                    }
                    .accessibilityLabel(
                        Text(currentPage == pages.count - 1
                            ? localizationService.text(.authSignUp)
                            : localizationService.text(.onboardingSkip))
                    )

                    Spacer()

                    Button(action: handleRightButton) {
                        if currentPage == pages.count - 1 {
                            Text(localizationService.text(.authSignIn))
                                .font(.headline)
                                .foregroundColor(.cyan)
                        } else {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.cyan)
                                .clipShape(Circle())
                                .accessibilityLabel(Text(localizationService.text(.onboardingNext)))
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, geo.safeAreaInsets.bottom)
            }
            .background(.clear)
        }
        .ignoresSafeArea(.container, edges: .top)
    }

    private func handleSkipOrSignUp() {
        if currentPage == pages.count - 1 {
            router.push(.signUp)
        } else {
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
