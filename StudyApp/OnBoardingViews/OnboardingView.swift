//
//  OnboardingView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 28/09/24.
//

import SwiftUI
import Combine

@MainActor let screenWidth = UIScreen.main.bounds.width
@MainActor let screenHeight = UIScreen.main.bounds.height

struct OnboardingView: View {
    let pages = [
        PageData(imageName: "StudyingFemale", title: "Find Your Favourite Class", description: "Find your favorite class. Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
        PageData(imageName: "student3", title: "Explore More Skills", description: "Learn from the best instructors and enhance your skills."),
        PageData(imageName: "student5", title: "Get the Best Class with Best Teacher", description: "Accelerate your learning journey and achieve your goals.")
    ]

    @State private var currentPage = 0
    @State private var showSignUpView = false
    @State private var showSignInView = false
    var router = Router<AuthRoute>()
    
    var body: some View {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                            .ignoresSafeArea(.container, edges: .top)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea(.container, edges: .top)

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.cyan : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                Spacer()

                HStack {
                    Button(action: {
                        if currentPage == 2 {
                            showSignUpView = true
                            router.push(.signUp)
                        } else {
                            currentPage = pages.count - 1
                        }
                    }) {
                        Text(currentPage == 2 ? "Sign Up" : "Skip")
                            .foregroundColor(.cyan)
                    }
                    Spacer()

                    Button(action: {
                        if currentPage == 2 {
                            showSignInView = true
                            router.push(.signIn)
                        } else {
                            currentPage += 1
                        }
                    }) {
                        if currentPage == 2 {
                            Text("Sign In" )
                                .foregroundColor(.cyan)
                        } else {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.cyan)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
            .background(Color.white)
            .ignoresSafeArea(.container, edges: .top) // ensure root content can draw under the notch
            .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingPageView: View {
    @State var page: PageData

    var body: some View {
        GeometryReader { geo in
            // Visible hero portion ~60% of screen height, but we add top inset so it extends under the notch.
            let baseHeroHeight = geo.size.height * 0.6
            let heroHeightWithInset = baseHeroHeight + geo.safeAreaInsets.top

            VStack(spacing: 0) {
                ZStack() {
                    Image(page.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: heroHeightWithInset)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .cyan.opacity(0.7)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(width: geo.size.width, height: heroHeightWithInset)
                        )
                    TopIcon_Title(title: "Study")
                        .padding(.top, geo.safeAreaInsets.top + 400)
                        .padding(.leading, 20)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 50)

                }
                // Important: the container uses the extended height, so it truly occupies the area under the status bar
                .frame(width: geo.size.width, height: heroHeightWithInset)
                .contentShape(Rectangle())
                .ignoresSafeArea(.container, edges: .top)
                .clipped()

                VStack(spacing: 20) {
                    Text(page.title)
                        .font(.system(size: 25, weight: .bold))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 24)

                    Text(page.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)

                Spacer(minLength: 0)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewDevice("iPhone 15 Pro")
            .environmentObject(AppCoordinator())
    }
}
