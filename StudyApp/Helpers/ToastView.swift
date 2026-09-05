//
//  ToastView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 29/07/26.
//

import SwiftUI

struct ToastDemoView: View {
    @State private var showToast = true
    var showToastPrompt: String {
        showToast ? "Hide Toast" : "Show Toast"
    }
    let text: String
    var body: some View {
        ZStack {
            Button {
                withAnimation {
                    showToast.toggle()
                }
            } label: {
                Text(showToastPrompt)
            }
        }
        .padding()
        .toast(text: text, showToast: $showToast)
    }
}

extension View {
    func toast(text: String, showToast: Binding<Bool>) -> some View {
        self
            .modifier(ToastModifier(text: text, showToast: showToast))
    }
}

struct ToastModifier: ViewModifier {
    let text: String
    @Binding var showToast: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            TextWithBackgroundView(text: text)
                .offset(y: showToast ? 0 : 100)
                .frame(maxHeight: .infinity, alignment: .bottom)

        }
    }
}


struct TextWithBackgroundView: View {
    let text: String
    let color: Color
    let textColor: Color
    init(
        text: String,
        color: Color = .orange.opacity(0.8),
        textColor: Color = .white
    ) {
        self.text = text
        self.color = color
        self.textColor = textColor
    }
    var body: some View {
        Text(text)
            .foregroundStyle(textColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(color)
            )
            .shadow(color: color, radius: 5, x: 0, y: 3)
    }
}

#Preview {
    ToastDemoView(text: "Toast is delicious")
}
