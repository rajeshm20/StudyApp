//
//  LaunchScreenView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/09/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    var router: Router<AuthRoute>

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Spacer()
                Menu {
                    ForEach(localizationService.supportedLanguages) { language in
                        Button {
                            localizationService.select(language: language)
                        } label: {
                            Label(
                                "\(language.flagEmoji) \(language.nativeName)",
                                systemImage: localizationService.currentLanguage == language ? "checkmark.circle.fill" : "globe"
                            )
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "globe")
                        Text(localizationService.text(.launchLanguageLabel))
                        Text(localizationService.currentLanguage.nativeName)
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.18))
                    .clipShape(Capsule())
                }
            }

            TopIcon_Title(title: localizationService.text(.appName))
                .padding(.top, 24)
            Spacer()
            Text(localizationService.text(.launchTitle))
                .font(.system(size: 40))
                .foregroundStyle(Color(.white))
                .multilineTextAlignment(.center)
                .bold()
                .padding(.bottom, 20)

            Text(localizationService.text(.launchSubtitle))
                .foregroundStyle(Color(.white))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .font(.system(size: 16))
                .padding(.horizontal, 20)
                .padding(.bottom, 30)

            Button(action: {
                router.push(.onboard)
            }, label: {
                Text(localizationService.text(.launchStartButton))
                    .font(.system(size: 20))
                    .bold()
                    .foregroundStyle(Color.white)
                    .frame(width: 180, height: 50)
                    .background(Color.cyan)
                    .clipShape(.buttonBorder)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background {
            Image(.smilingFemale2)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.2), .blue.opacity(0.6), .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    @Previewable var router = Router<AuthRoute>()
    LaunchScreenView(router: router)
}
