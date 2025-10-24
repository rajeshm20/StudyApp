struct TextEditorWithCompletion: View {
    @State private var text = ""
    @FocusState private var isFocused: Bool
    
    var completion: () -> Void
    
    var body: some View {
        TextEditor(text: $text)
            .focused($isFocused)
            .onChange(of: text) { _ in
                completion() // triggers whenever text changes
            }
            .onChange(of: isFocused) { focused in
                if !focused {
                    completion() // triggers when editing ends
                }
            }
            .frame(height: 120)
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