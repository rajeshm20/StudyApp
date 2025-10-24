
struct NavigationIconView: View {
    let icon: String
    let title: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {}) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(backgroundColor)
                    .clipShape(Circle())
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}
