//
//  RowView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 03/05/25.
//

import SwiftUI

struct ReusableRow<Footer: View>: View {
    let title: String
    let subtitle: String
    let bodyText: String
    let rightIconName: String
    let rightIconAction: () -> Void
    @ViewBuilder let footer: () -> Footer

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: rightIconAction) {
                    Image(systemName: rightIconName)
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            Text(bodyText)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            footer()
                .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    ReusableRow(title: "Title", subtitle: "SubTitle", bodyText: "lorem ipsumkdjflskdjflskdjf kdjflskdj ldfjsl d", rightIconName: "plus", rightIconAction: { print("Hello") }, footer: {                     HStack {
        Text("Footer text")
            .font(.footnote)
            .foregroundColor(.secondary)
        Spacer()
        Button("Action") { print("Footer action") }
            .font(.footnote)
    }
})
}
