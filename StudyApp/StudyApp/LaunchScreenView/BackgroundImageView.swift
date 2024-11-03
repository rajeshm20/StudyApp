//
//  BackgroundImageView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 29/09/24.
//

import SwiftUI

// Reusable Background Image with Gradient Overlay
struct BackgroundImageView: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // First Half: Background image with gradient overlay
                BackgroundImageWithOverlay(
                    imageName: imageName,
                    gradientColors: [.clear, .cyan.opacity(0.7)],
                    height: geometry.size.height / 1.5, title: title  // Half the screen height
                )
                
                // Second Half: Text overlay
                TextOverlayView(
                    title: title,
                    description: description,
                    height: geometry.size.height / 2  // Half the screen height
                )
            }
            .ignoresSafeArea()  // Ensure content fills the screen
        }
    }
}
// Reusable Background Image with Gradient Overlay
// Reusable Background Image with Gradient Overlay
struct BackgroundImageWithOverlay: View {
    var imageName: String
    var gradientColors: [Color]
    var height: CGFloat  // Added height parameter to control the height dynamically
    @State var title: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: height)  // Set the height
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .opacity(0.7)
                )
                .clipped()  // Clip the image to avoid overflow
                .overlay {
                    TopIcon_Title(title: title)
                        .offset(y:200)
                }
        }
    }
}

// Reusable Text Overlay with Title and Description
struct TextOverlayView: View {
    var title: String
    var description: String
    var height: CGFloat  // Added height parameter to control the height dynamically
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: height)  // Set the height dynamically
            VStack(alignment: .center) {
                Text(title)
                    .font(.system(size: 25, weight: .bold))
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                    .scenePadding(.minimum, edges: [.leading, .trailing])
                Text(description)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                HStack(alignment: .center) {
                    Button(action: {
                        
                    }){
                        Text("Skip")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.cyan)
                    }
                    Spacer()
                    Button(action: {
                        // Define button action here
                        print("Button tapped!")
                    }){
                        Image(systemName: "arrow.right") // Right arrow symbol
                            .font(.system(size: 18, weight: .bold)) // Adjust arrow size and weight
                            .foregroundColor(.white) // Arrow color
                            .frame(width: 50, height: 50) // Button size
                            .background(Color.cyan) // Button background color
                            .clipShape(Circle()) // Make it circular
                    }
                }
                .padding(.trailing, 30)
                Spacer()
            }

        }
    }
}



