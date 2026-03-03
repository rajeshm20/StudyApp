import SwiftUI

struct FilterBottomSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilter = "See all assignments"

    let filters = [
        "See all assignments",
        "New Assignments",
        "Ongoing Assignments",
        "Completed Assignments",
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top grab indicator
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 12)

            // Title
            Text("Choose your filter")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.bottom, 24)

            // List of filters (no dividers)
            VStack(spacing: 6) {
                ForEach(filters, id: \.self) { filter in
                    Button {
                        selectedFilter = filter
                        dismiss()
                    } label: {
                        HStack {
                            Text(filter)
                                .font(.system(size: 16))
                                .foregroundColor(
                                    filter == selectedFilter ? Color.blue : Color.primary.opacity(0.8)
                                )
                                .fontWeight(filter == selectedFilter ? .semibold : .regular)

                            Spacer()

                            if filter == selectedFilter {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(filter == selectedFilter ? Color.blue.opacity(0.08) : Color.clear)
                        )
                    }
                }
            }

            Spacer(minLength: 12)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: -2)
                .ignoresSafeArea(edges: [.horizontal, .bottom])
        )
    }
}

#Preview {
    FilterBottomSheet()
        .presentationDetents([.fraction(0.38)])
        .presentationDragIndicator(.hidden)
}
