//
//  TextEditorWithCompletion.swift
//  StudyApp
//
//  Created by Rajesh Mani on 19/10/25.
//
import SwiftUI

struct TextEditorWithCompletion: View {
    @State var text = ""
    @FocusState private var isFocused: Bool
    
    var completion: () -> Void
    
    var body: some View {
        TextEditor(text: $text)
            .focused($isFocused)
            .onChange(of: text) { _, _ in
                completion() // triggers whenever text changes
            }
            .onChange(of: isFocused) { _, focused in
                if !focused {
                    completion() // triggers when editing ends
                }
            }
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .init(horizontal: .leading, vertical: .top))
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .toolbar {
                // Optional: a Done button to dismiss keyboard manually
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
    }
}
