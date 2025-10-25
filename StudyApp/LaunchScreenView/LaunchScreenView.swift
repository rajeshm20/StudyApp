//
//  LaunchScreenView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/09/24.
//

import SwiftUI
import Combine

struct LaunchScreenView: View {
    @State private var title: String = "Study"
    @State private var navigateToOnboard = false
    var router: Router<AuthRoute>

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                TopIcon_Title(title: title)
                Spacer() // Adds space at the top
                // First Text
                Text("Hello and \nwelcome here!")
                    .font(.system(size: 40))
                    .foregroundStyle(Color(.white))
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(.bottom, 20)
                
                // Second Text
                Text("Get an overview of how you are performing \nand motivate yourself to achieve even more!")
                    .foregroundStyle(Color(.white))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .font(.system(size: 16))
                    .padding(.horizontal, 20) // Control the horizontal padding to avoid text overflow
                    .padding(.bottom, 30) // Adds space below text
                Button(action: {
                    navigateToOnboard = true
                    router.push(.onboard)
                }, label: {
                    Text("Let's Start")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.cyan)
                        .clipShape(.buttonBorder)
                })
//                .navigationDestination(isPresented: $navigateToOnboard) {
//                    OnboardingView()
//                        .navigationBarBackButtonHidden(true)
//                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding() // Ensure content respects safe areas
            .background {
                Image("smilingFemale2")
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Use aspectRatio to fill but avoid excessive scaling
                    .ignoresSafeArea() // Ensure it fills the entire screen without interfering with content layout
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.2), .blue.opacity(0.6), .blue]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    @Previewable var router: Router<AuthRoute> = Router<AuthRoute>()
    LaunchScreenView(router: router)
}
