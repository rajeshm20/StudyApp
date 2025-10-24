// 1️⃣ Popup Manager
class PopupManager: ObservableObject {
    @Published var isVisible = false
    @Published var title = ""
    @Published var message = ""
    
    func show(title: String, message: String) {
        withAnimation {
            self.title = title
            self.message = message
            self.isVisible = true
        }
        // Auto dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { self.isVisible = false }
        }
    }
}