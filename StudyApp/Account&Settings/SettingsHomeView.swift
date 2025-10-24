//
//  SettingsHomeView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 14/10/25.
//


import SwiftUI

struct SettingsHomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: - Header
                VStack(spacing: 20) {
                    // App title
                    TopIcon_Title(title: "Study")
                    
                    // User Info
                    HStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .foregroundColor(Color.primaryBlue.opacity(0.9))
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Welcome")
                                .font(.system(size: 14))
                                .foregroundColor(Color.gray)
                            Text("Marvin McKinney")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right.circle")
                            .font(.system(size: 22))
                            .foregroundColor(Color.gray.opacity(0.7))
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 25)
                
                Divider()
                    .padding(.horizontal, 24)
                
                // MARK: - Menu List
                VStack(spacing: 20) {
                    NavigationLink(destination: ProfileView11()) {
                        SettingsRow(icon: "person", title: "Profile")
                    }
                    NavigationLink(destination: AccountView()) {
                        SettingsRow(icon: "shield", title: "Account")
                    }
                    NavigationLink(destination: SettingView()) {
                        SettingsRow(icon: "gearshape", title: "Setting")
                    }
                    NavigationLink(destination: AboutView()) {
                        SettingsRow(icon: "questionmark.circle", title: "About")
                    }
                }
                .padding(.top, 28)
                
                Spacer(minLength: 100)

                // MARK: - Help Card
                HelpCardView()
//                VStack {
//                    HStack(spacing: 10) {
//                        Image(systemName: "headphones")
//                            .font(.system(size: 20, weight: .medium))
//                        Text("How can we help you?")
//                            .font(.system(size: 16, weight: .semibold))
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(.white)
//                    .background(Color("themeColor"))
//                    .cornerRadius(12)
//                }
//                .padding(.horizontal, 24)
//                .padding(.top, 10)
                
                Spacer(minLength: 100)
                // MARK: - Footer
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Text("Privacy Policy")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                        
                        Text("Terms")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                        
                        HStack(spacing: 4) {
                            Text("English")
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                        }
                    }
                    .font(.system(size: 13))
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 8)
                Spacer()
                }
                .padding(.bottom, 8)
            }
            .navigationBarHidden(true)
            .background(Color.white.ignoresSafeArea())
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color("themeColor").opacity(0.12))
                    .frame(width: 42, height: 42)
                Image(systemName: icon)
                    .foregroundColor(Color("themeColor"))
                    .font(.system(size: 18))
            }
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Dummy Pages
struct ProfileView11: View {
    var body: some View {
        Text("Profile Page")
            .font(.title2)
            .navigationTitle("Profile")
    }
}

struct AccountView: View {
    var body: some View {
        Text("Account Page")
            .font(.title2)
            .navigationTitle("Account")
    }
}

struct SettingView: View {
    var body: some View {
        Text("Setting Page")
            .font(.title2)
            .navigationTitle("Setting")
    }
}

struct AboutView: View {
    var body: some View {
        Text("About Page")
            .font(.title2)
            .navigationTitle("About")
    }
}

// MARK: - Custom Color Extension
extension Color {
    static let primaryBlue = Color("themeColor")
}

// MARK: - Preview
struct SettingsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHomeView()
            .environment(\.colorScheme, .light)
            .preferredColorScheme(.light)
    }
}

struct HelpCardView: View {
    var body: some View {
        ZStack {
            // MARK: - Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.theme,
                    Color.theme.opacity(0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(14)
            .shadow(color: Color.theme.opacity(0.2), radius: 6, x: 0, y: 2)

            // MARK: - Decorative Circles
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: geo.size.width * 0.35)
                        .offset(x: geo.size.width * 0.65, y: -geo.size.height * 0.25)
                    
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: geo.size.width * 0.25)
                        .offset(x: geo.size.width * 0.6, y: geo.size.height * 0.2)
                    
                    Circle()
                        .fill(Color.white.opacity(0.24))
                        .frame(width: geo.size.width * 0.18)
                        .offset(x: -geo.size.width * 0.6, y: geo.size.height * 0.3)
                    
                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: geo.size.width * 0.1)
                        .offset(x: -geo.size.width * 0.4, y: -geo.size.height * 0.25)
                }
            }
            .clipped()
            .cornerRadius(14)

            // MARK: - Foreground Content
            HStack(spacing: 14) {
                ZStack {
                    DottedArc(startAngle: .degrees(190), endAngle: .degrees(-60))
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 56, height: 56)
                    Image(systemName: "headphones")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("How can we help you?")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
        }
        .frame(height: 80)
        .padding(.horizontal, 24)
        .padding(.top, 14)
    }
}

struct DottedArc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var dotCount: Int = 40
    var radius: CGFloat = 26

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angleRange = endAngle.radians - startAngle.radians

        for i in 0..<dotCount {
            let t = CGFloat(i) / CGFloat(dotCount - 1)
            let angle = startAngle.radians + angleRange * Double(t)
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            path.addEllipse(in: CGRect(x: x - 1.2, y: y - 1.2, width: 2.4, height: 2.4))
        }
        return path
    }
}
