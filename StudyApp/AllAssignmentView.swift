import SwiftUI

// MARK: - Models
struct Assignment: Identifiable, Codable {
    let id: String
    let title: String
    let dueDate: String
    let daysLeft: Int
    let status: String
    let colorHex: String
    let icon: String
    
    var color: Color {
        Color(hex: colorHex)
    }
}


// MARK: - Data Manager
@MainActor
class AssignmentDataManager: ObservableObject {
    @Published var assignments: [Assignment] = []
    @Published var isLoading = true
    
    init() {
        Task {
            await loadMockData()
        }
    }
    
    func loadMockData() async {
        try? await Task.sleep(nanoseconds: 600_000_000) // Simulate 0.6s delay
        let mockJSON = """
        [
            {
                "id": "1",
                "title": "Doing personal tasks",
                "dueDate": "12/08/2021",
                "daysLeft": 3,
                "status": "completed",
                "colorHex": "#2ECC71",
                "icon": "checkmark.circle.fill"
            },
            {
                "id": "2",
                "title": "Doing personal tasks",
                "dueDate": "12/08/2021",
                "daysLeft": 3,
                "status": "overdue",
                "colorHex": "#E74C3C",
                "icon": "xmark.circle.fill"
            },
            {
                "id": "3",
                "title": "Doing personal tasks",
                "dueDate": "12/08/2021",
                "daysLeft": 3,
                "status": "inProgress",
                "colorHex": "#F39C12",
                "icon": "chart.bar.fill"
            }
        ]
        """
        
        if let data = mockJSON.data(using: .utf8) {
            do {
                let decoded = try JSONDecoder().decode([Assignment].self, from: data)
                assignments = decoded
            } catch {
                print("Decoding error:", error)
                assignments = []
            }
        }
        isLoading = false
    }
}

// MARK: - Main Screen
struct AssignmentCalendarScreen: View {
    @Binding var showListView: Bool
    @State private var selectedDate = Date()
    @StateObject private var dataManager = AssignmentDataManager()
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Text("All Assignments")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Button(action: {showListView = true}) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.gray)
                                .frame(width: 32, height: 32)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                                
                // Calendar
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding(.horizontal, 12)
                    .tint(.blue)
                
                // Pull handle
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 4)
                    .cornerRadius(2)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if dataManager.isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading assignments...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 6)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Assignment List
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(dataManager.assignments) { assignment in
                                AssignmentCard1(assignment: assignment)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
    }
    
    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        let year = Calendar.current.component(.year, from: date)
        return "\(month) \(year)"
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

// MARK: - Card View
struct AssignmentCard1: View {
    let assignment: Assignment
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: assignment.icon)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(assignment.color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(assignment.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(assignment.dueDate)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text("\(assignment.daysLeft) Days")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    AssignmentCalendarScreen(showListView: .constant(true))
}
