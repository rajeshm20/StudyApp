//
//  ListView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 03/05/25.
//

import SwiftUI

struct ListView: View {
    struct Item: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let bodyText: String
    }

    let items = [
        Item(title: "Math", subtitle: "Algebra", bodyText: "Practice linear equations"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
        Item(title: "Science", subtitle: "Biology", bodyText: "Study cell structure"),
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(items) { item in
                    ReusableRow(
                        title: item.title,
                        subtitle: item.subtitle,
                        bodyText: item.bodyText,
                        rightIconName: "pencil",
                        rightIconAction: {
                            print("Edit tapped for \(item.title)")
                        },
                        footer: {
                            HStack {
                                Text("More info")
                                    .font(.footnote)
                                Spacer()
                                Button("Details") {
                                    print("Details tapped for \(item.title)")
                                }
                                .font(.footnote)
                            }
                        }
                    )
                }
            }
        }
//        List(items) { item in
//            HStack {
//                Text(item.title)
//                Spacer()
//                Button(action: {
//                    // Action for first button, eg. edit
//                    print("Edit tapped for \(item.title)")
//                }) {
//                    Image(systemName: "pencil")
//                }
//                .buttonStyle(.borderless)
//
//                Button(action: {
//                    // Action for second button, eg. delete
//                    print("Delete tapped for \(item.title)")
//                }) {
//                    Image(systemName: "trash")
//                }
//                .buttonStyle(.borderless)
//            }
//        }
        .listStyle(.insetGrouped)
        .padding(20)
        .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

#Preview {
    ListView()
}
