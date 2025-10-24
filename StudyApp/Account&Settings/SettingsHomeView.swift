//
//  SettingsHomeView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 14/10/25.
//

import SwiftUI

struct SettingsHomeView: View {
    var img: ImageResource?
    @State private var profileUIImage: UIImage?
    @State private var profile = Profile()
    @State private var navigationManager = NavigationManager()
    var router: Router<MainRoute>
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
//        NavigationStack(path: $navigationManager.path) {
            VStack(spacing: 0) {
                
                // MARK: - Header
                VStack(spacing: 20) {
                    // App title
                    TopIcon_Title(title: "Study")
                    
                    // User Info
                    HStack(spacing: 14) {
                        if let uiImage = profileUIImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 54, height: 54)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1)))
                        } else if let image = img {
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("themeColor"))
                                .font(.system(size: 18))
                                .frame(width: 54, height: 54)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1)))
                        }
                        else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 54, height: 54)
                                .clipShape(Circle())
                                .foregroundColor(Color.primaryBlue.opacity(0.9))
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Welcome")
                                .font(.system(size: 14))
                                .foregroundColor(Color.gray)
                            Text(profile.name)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        Button(action: {
                            coordinator.switchToAuth()
                        }) {
                            Image(systemName: "arrow.right.circle")
                                .font(.system(size: 22))
                                .foregroundColor(Color.gray.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 25)
                
                Divider()
                    .padding(.horizontal, 24)
                
                // MARK: - Menu List
                Group {
                    Button(action: {
                        router.push(.profile)
                    }, label: {
                        SettingsRow(icon: "person", title: "Profile")
                    })
                    Button(action: {
                        router.push(.account)
                    }, label: {
                        SettingsRow(icon: "shield", title: "Account")
                    })
                    Button(action: {
                        router.push(.settings)
                    }, label: {
                        SettingsRow(icon: "gearshape", title: "Setting")
                    })
                    Button(action: {
                        router.push(.aboutus)
                    }, label: {
                        SettingsRow(icon: "questionmark.circle", title: "About")
                    })
                }
                .padding(.top, 28)
                
                Spacer(minLength: 50)
                
                // MARK: - Help Card
                HelpCardView()
                    .onTapGesture(perform: {
                        router.push(.aboutus)
                    })
                
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
            .onAppear {
                loadSavedProfileImage()
            }
//        }
    }

    // MARK: - Persistence helpers (match ProfilePictureView)
    private var profileImageURL: URL? {
        do {
            let documents = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return documents.appendingPathComponent("profile.jpg")
        } catch {
            print("❌ Could not get Documents directory:", error)
            return nil
        }
    }

    private func loadSavedProfileImage() {
        guard let fileURL = profileImageURL else { return }
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            profileUIImage = nil
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            profileUIImage = UIImage(data: data)
        } catch {
            print("❌ Failed to load saved profile image:", error)
        }
    }
    
//    @ViewBuilder
//    private func destinationView(for destination: AppDestination) -> some View {
//        switch destination {
//        case .profile(_):
//            ProfilePageView()
//        case .account:
//            AccountView()
//        case .settings:
//            SettingsView()
//        case .about:
//            AboutUsView()
//        case .help:
//            EmptyView()
//        default:
//            EmptyView()
//        }
//    }

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

// MARK: - Custom Color Extension
extension Color {
    static let primaryBlue = Color("themeColor")
}

// MARK: - Preview
struct SettingsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsHomeView(img: .student3, router: Router<MainRoute>())
                .environment(\.colorScheme, .light)
                .preferredColorScheme(.light)
                .environmentObject(PopupManager())
        }
    }
}

struct HelpCardView: View {
    var body: some View {
        ZStack {
            // MARK: - Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.cyan,
                    Color.gray.opacity(0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(14)
            .shadow(color: Color.yellow.opacity(0.2), radius: 6, x: 0, y: 2)

            // MARK: - Decorative Circles
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: geo.size.width * 0.35)
                        .offset(x: geo.size.width * 0.65, y: -geo.size.height * 0.20)
                }
            }
            .clipped()
            .cornerRadius(14)

            // MARK: - Ad Content
            HStack(spacing: 14) {
                ZStack {
                    DottedArc(startAngle: .degrees(180), endAngle: .degrees(-90))
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
