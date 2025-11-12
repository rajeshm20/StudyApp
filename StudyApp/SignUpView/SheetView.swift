//
//  SheetView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 14/04/25.
//

import SwiftUI

struct SheetView: View {
    @State var isShowingMyCustomSheet = false
        
        var body: some View {
            VStack {
                Button("Toggle the Sheet") {
                    isShowingMyCustomSheet.toggle()
                }
            }
            .padding()
            .sheet(isPresented: $isShowingMyCustomSheet) {
                // Our short sheet API
                MySheetView()
            }
        }
}


struct MySheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.white)
                }
            }.padding()
            
            Spacer()
            // If you want this image for your project, you can save the title
            // image from this article to your project file
            Image(.init(".star") ?? ".star")
                .resizable()
                .scaledToFit()
            Spacer()
        }
        .background(Gradient(colors: [.blue, .cyan, .cyan.opacity(0.5) ,.green, .yellow, .yellow.opacity(0.6)]).opacity(0.3))
    }
}

#Preview {
    SheetView()
}
