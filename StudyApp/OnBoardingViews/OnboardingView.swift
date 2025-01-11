//
//  OnboardingView_1.swift
//  StudyApp
//
//  Created by Rajesh Mani on 28/09/24.
//

import SwiftUI

struct OnboardingView: View {
    let pages = [
        PageData1(imageName: "student5", title: "Find Your Favourite Class", description: "Find your favorite class. Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
        PageData1(imageName: "student3", title: "Explore More Skills", description: "Learn from the best instructors and enhance your skills."),
        PageData1(imageName: "thumbsUp", title: "Get the Best Class with Best Teacher", description: "Accelerate your learning journey and achieve your goals.")
    ]

    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .ignoresSafeArea()
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Remove default dot pagination
            // Custom Pagination Indicator
            HStack(spacing: 8) {
                ForEach(0..<pages.count) { index in
                    Circle()
                        .fill(currentPage == index ? Color.cyan : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            Spacer()
            
            HStack {
                Button(action: {
                    // Skip button action
                }) {
                    Text("Skip")
                        .foregroundColor(.cyan)
                }
                
                Spacer()
                
                // Next Button
                Button(action: {
                    if currentPage < pages.count - 1 {
                        currentPage += 1
                    }
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.cyan)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .background(Color.white)
    }
}

struct OnboardingPageView: View {
   @State var page: PageData1
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image(page.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 500)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .cyan.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 500)
                    )
                    .overlay(
                        VStack {
                            TopIcon_Title(title: "Study")
                        }
                        .offset(y: 180)
                    )
                    .ignoresSafeArea(edges: .top)  // Ensures the image ignores the safe area at the top
            }


            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(size: 25, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(height:60)
                Text(page.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .frame(height:50)
            }
            .padding(.bottom, 50)
            Spacer()
        }
    }
}

// Data Model for Onboarding Page
struct PageData1 {
    var imageName: String
    var title: String
    var description: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
