//
//  GridView_Example.swift
//  StudyApp
//
//  Created by Rajesh Mani on 30/03/25.
//

import SwiftUI

struct GridView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

//    var body: some View {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 20) {
//                    ForEach(0..<50) { index in
//                        Text("Item \(index)")
//                            .frame(height: 50)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue.opacity(0.2))
//                            .cornerRadius(8)
//                    }
//                }
//                .padding()
//            }
//        }

    var body: some View {
        VStack {
            Text("ViewThatFits Example")
                .font(.title)
                .padding()
                .dynamicTypeSize(.medium) // disables accessibility scaling
            // First option (highest priority) - full view
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("This is the complete text that will be displayed if there's enough space")
                    .dynamicTypeSize(.medium) // disables accessibility scaling
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))

            // Second option - more compact view
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .dynamicTypeSize(.medium) // disables accessibility scaling
                Text("Shorter text")
                    .dynamicTypeSize(.medium) // disables accessibility scaling
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.2)))

            // Third option - minimal view
            Text("Minimal")
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.0)))
                .dynamicTypeSize(.medium) // disables accessibility scaling

            Spacer()

            Text("Try changing the screen size to see the view adapt")
                .font(.caption)
                .padding()
                .dynamicTypeSize(.medium) // disables accessibility scaling
        }
    }
}

#Preview {
    GridView()
}
