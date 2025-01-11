//
//  LaunchScreenView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/09/24.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
            VStack(alignment: .center) {
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 30, height: 30)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue.opacity(0.8))
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.white)

                    }
                    Text("Study")
                        .fontWeight(.heavy)
                        .foregroundStyle(Color(.white))
                }

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
                    
                }, label: {
                    Text("Let's Start")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.cyan)
                        .clipShape(.buttonBorder)
                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding() // Ensure content respects safe areas
            .background {
                Image("smilingFemale")
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Use aspectRatio to fill but avoid excessive scaling
                    .ignoresSafeArea() // Ensure it fills the entire screen without interfering with content layout
                LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.8)
                    .ignoresSafeArea()
            }
        }
        
}

#Preview {
    LaunchScreenView()
}
