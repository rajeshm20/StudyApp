//
//  MyClassView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 11/11/25.
//

import SwiftUI

struct MyClassView: View {
    var router: Router<MainRoute>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MyClassView(router: Router<MainRoute>())
}
