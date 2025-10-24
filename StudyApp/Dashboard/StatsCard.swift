struct StatsCard: View {
    let value: String
    let title: String
    let valueColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(valueColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
