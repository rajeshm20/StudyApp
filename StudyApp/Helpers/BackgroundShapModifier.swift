//
//  BackgroundShapModifier.swift
//  StudyApp
//
//  Created by Rajesh Mani on 30/07/26.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .backgroundShape(shape: .rect(cornerRadius: 6), color: .green)
            .padding()
        Text("Hello World!")
            .backgroundShape(shape:
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 30,
                                    bottomLeadingRadius: 0, bottomTrailingRadius:  30, topTrailingRadius: 0,
                                    style: .continuous
                                )
                             , color: .cyan)
                            .padding()

    }
}

extension View {
    func backgroundShape<S: Shape>(shape: S, color: Color) -> some View  {
        self
            .modifier(
                BackgroundShapModifier(
                    shape: shape,
                    Color: color
                )
            )

    }
}

#Preview {
    BackgroundView()
}


struct BackgroundShapModifier<S>: ViewModifier where S: Shape {
    var shape: S
    var Color: Color

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color)
            .clipShape(shape)
    }
}
