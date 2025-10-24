struct ScheduleItem: View {
    let subject: String
    let color: Color
    let startColumn: Int
    let span: Int
    
    var body: some View {
        HStack {
            ForEach(0..<6, id: \.self) { index in
                if index >= startColumn && index < startColumn + span {
                    if index == startColumn {
                        Text(subject)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(color)
                            .cornerRadius(6)
                    } else {
                        Rectangle()
                            .fill(color)
                            .frame(height: 32)
                            .cornerRadius(6)
                    }
                } else {
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}