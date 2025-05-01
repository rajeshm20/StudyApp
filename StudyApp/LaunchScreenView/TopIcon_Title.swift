//
//  TopIcon_Title.swift
//  StudyApp
//
//  Created by Rajesh Mani on 28/09/24.
//

import SwiftUI

struct TopIcon_Title: View {
    var title:String
    var body: some View {
        
        HStack {
            ZStack {
                Rectangle()
                    .frame(width: 30, height: 30)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.cyan.opacity(0.8))
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.white)

            }
            Text(title)
                .fontWeight(.heavy)
                .foregroundStyle(Color(.white))
        }
    }
        
}

#Preview {
    TopIcon_Title(title: "Study")
}
