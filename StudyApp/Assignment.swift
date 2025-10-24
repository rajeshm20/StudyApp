import SwiftUI
import Foundation

// MARK: - Data Models
struct Assignment: Codable, Identifiable {
    let id: String
    let title: String
    let dueDate: String
    let status: AssignmentStatus
    let category: String
    let daysLeft: Int
}

enum AssignmentStatus: String, Codable, CaseIterable {
    case completed = "completed"
    case overdue = "overdue"
    case inProgress = "in_progress"
    case pending = "pending"
    
    var iconName: String {
        switch self {
        case .completed: return "checkmark.square.fill"
        case .overdue: return "xmark.square.fill"
        case .inProgress: return "chart.line.uptrend.xyaxis"
        case .pending: return "clock.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .completed: return .green
        case .overdue: return .red
        case .inProgress: return .orange
        case .pending: return .blue
        }
    }
}

struct CalendarData: Codable {
    let currentMonth: String
    let currentYear: Int
    let selectedDate: Int
    let assignments: [Assignment]
}

// MARK: - Data Manager
class AssignmentDataManager: ObservableObject {
    @Published var calendarData: CalendarData?
    @Published var isLoading = true
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.calendarData = self.getMockData()
            self.isLoading = false
        }
    }
    
    private func getMockData() -> CalendarData {
        let mockJSON = """
        {
            "currentMonth": "August",
            "currentYear": 2021,
            "selectedDate": 6,
            "assignments": [
                {
                    "id": "1",
                    "title": "Complete Math Assignment",
                    "dueDate": "12/08/2021",
                    "status": "completed",
                    "category": "Mathematics",
                    "daysLeft": 3
                },
                {
                    "id": "2",
                    "title": "Submit History Essay",
                    "dueDate": "12/08/2021",
                    "status": "overdue",
                    "category": "History",
                    "daysLeft": -1
                },
                {
                    "id": "3",
                    "title": "Science Lab Report",
                    "dueDate": "12/08/2021",
                    "status": "in_progress",
                    "category": "Science",
                    "daysLeft": 2
                },
                {
                    "id": "4",
                    "title": "English Literature Review",
                    "dueDate": "15/08/2021",
                    "status": "pending",
                    "category": "English",
                    "daysLeft": 5
                },
                {
                    "id": "5",
                    "title": "Physics Problem Set",
                    "dueDate": "18/08/2021",
                    "status": "in_progress",
                    "category": "Physics",
                    "daysLeft": 8
                }
            ]
        }
        """
        
        guard let data = mockJSON.data(using: .utf8),
              let calendarData = try? JSONDecoder().decode(CalendarData.self, from: data) else {
            // Fallback data
            return CalendarData(
                currentMonth: "August",
                currentYear: 2021,
                selectedDate: 6,
                assignments: []
            )
        }
        
        return calendarData
    }
}

// MARK: - Main View
struct AssignmentCalendarView: View {
    @StateObject private var dataManager = AssignmentDataManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("All Assignments")
                        .font(.largeTitle)
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
                        
                        Button(action: {}) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.gray)
                                .frame(width: 32, height: 32)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if dataManager.isLoading {
                    // Loading State
                    VStack {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading assignments...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let calendarData = dataManager.calendarData {
                    // Calendar Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(calendarData.currentMonth)
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                Button(action: {}) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.gray)
                                }
                                
                                Button(action: {}) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        // Calendar Grid
                        CalendarGridView(selectedDate: calendarData.selectedDate)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    // Assignment List
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 4)
                            .cornerRadius(2)
                            .padding(.vertical, 16)
                        
                        LazyVStack(spacing: 0) {
                            ForEach(calendarData.assignments) { assignment in
                                AssignmentRowView(assignment: assignment)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Tab Bar
                    TabBarView()
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Calendar Grid View
struct CalendarGridView: View {
    let selectedDate: Int
    
    var body: some View {
        VStack(spacing: 12) {
            // Week days header
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar days
            VStack(spacing: 16) {
                // Week 1
                HStack {
                    CalendarDayView(day: 1, isSelected: selectedDate == 1)
                    CalendarDayView(day: 2, isSelected: selectedDate == 2)
                    CalendarDayView(day: 3, isSelected: selectedDate == 3)
                    CalendarDayView(day: 4, isSelected: selectedDate == 4)
                    CalendarDayView(day: 5, isSelected: selectedDate == 5)
                    CalendarDayView(day: 6, isSelected: selectedDate == 6)
                    CalendarDayView(day: 7, isSelected: selectedDate == 7)
                }
                
                // Week 2
                HStack {
                    CalendarDayView(day: 8, isSelected: selectedDate == 8)
                    CalendarDayView(day: 9, isSelected: selectedDate == 9)
                    CalendarDayView(day: 10, isSelected: selectedDate == 10)
                    CalendarDayView(day: 11, isSelected: selectedDate == 11)
                    CalendarDayView(day: 12, isSelected: selectedDate == 12)
                    CalendarDayView(day: 13, isSelected: selectedDate == 13)
                    CalendarDayView(day: 14, isSelected: selectedDate == 14)
                }
                
                // Week 3
                HStack {
                    CalendarDayView(day: 15, isSelected: selectedDate == 15)
                    CalendarDayView(day: 16, isSelected: selectedDate == 16)
                    CalendarDayView(day: 17, isSelected: selectedDate == 17)
                    CalendarDayView(day: 18, isSelected: selectedDate == 18)
                    CalendarDayView(day: 19, isSelected: selectedDate == 19)
                    CalendarDayView(day: 20, isSelected: selectedDate == 20)
                    CalendarDayView(day: 21, isSelected: selectedDate == 21)
                }
                
                // Week 4
                HStack {
                    CalendarDayView(day: 22, isSelected: selectedDate == 22)
                    CalendarDayView(day: 23, isSelected: selectedDate == 23)
                    CalendarDayView(day: 24, isSelected: selectedDate == 24)
                    CalendarDayView(day: 25, isSelected: selectedDate == 25)
                    CalendarDayView(day: 26, isSelected: selectedDate == 26)
                    CalendarDayView(day: 27, isSelected: selectedDate == 27)
                    CalendarDayView(day: 28, isSelected: selectedDate == 28)
                }
                
                // Week 5
                HStack {
                    CalendarDayView(day: 29, isSelected: selectedDate == 29)
                    CalendarDayView(day: 30, isSelected: selectedDate == 30)
                    CalendarDayView(day: 31, isSelected: selectedDate == 31)
                    CalendarDayView(day: 1, isNextMonth: true)
                    CalendarDayView(day: 2, isNextMonth: true)
                    CalendarDayView(day: 3, isNextMonth: true)
                    CalendarDayView(day: 4, isNextMonth: true)
                }
            }
        }
    }
}

// MARK: - Calendar Day View
struct CalendarDayView: View {
    let day: Int
    var isSelected: Bool = false
    var isNextMonth: Bool = false
    
    var body: some View {
        Text("\(day)")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(isNextMonth ? .gray.opacity(0.4) : (isSelected ? .white : .primary))
            .frame(width: 40, height: 40)
            .background(isSelected ? Color.blue : Color.clear)
            .clipShape(Circle())
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Assignment Row View
struct AssignmentRowView: View {
    let assignment: Assignment
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: assignment.status.iconName)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(assignment.status.color)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(assignment.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(assignment.dueDate)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text(daysLeftText)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(daysLeftColor)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var daysLeftText: String {
        if assignment.daysLeft < 0 {
            return "Overdue"
        } else if assignment.daysLeft == 0 {
            return "Due Today"
        } else {
            return "\(assignment.daysLeft) Days"
        }
    }
    
    private var daysLeftColor: Color {
        if assignment.daysLeft < 0 {
            return .red
        } else if assignment.daysLeft == 0 {
            return .orange
        } else {
            return .blue
        }
    }
}

// MARK: - Tab Bar View
struct TabBarView: View {
    var body: some View {
        HStack {
            TabBarItem(icon: "square.grid.2x2", isSelected: false)
            TabBarItem(icon: "calendar", isSelected: true)
            TabBarItem(icon: "doc.text", isSelected: false)
            TabBarItem(icon: "person", isSelected: false)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .background(Color.white)
    }
}

// MARK: - Tab Bar Item
struct TabBarItem: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Content View
struct ContentView: View {
    var body: some View {
        AssignmentCalendarView()
    }
}

#Preview {
    ContentView()
}