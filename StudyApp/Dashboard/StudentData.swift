import SwiftUI

// MARK: - Data Models
struct StudentData: Codable {
    let name: String
    let greeting: String
    let stats: StudentStats
    let navigationItems: [NavigationItem]
    let schedule: [ScheduleClass]
}

struct StudentStats: Codable {
    let presence: Int
    let completeness: Int
    let assignments: Int
    let totalSubjects: Int
}

struct NavigationItem: Codable, Identifiable {
    let id: String
    let title: String
    let icon: String
    let backgroundColor: String
}

struct ScheduleClass: Codable, Identifiable {
    let id: String
    let subject: String
    let startHour: Int
    let duration: Int
    let color: String
}

// MARK: - Data Service
class StudentDataService: ObservableObject {
    @Published var studentData: StudentData?
    @Published var isLoading = true
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.studentData = self.getMockStudentData()
            self.isLoading = false
        }
    }
    
    private func getMockStudentData() -> StudentData {
        // Mock JSON data that would typically come from an API
        let mockJSON = """
        {
            "name": "Jenny Wilson",
            "greeting": "Here is your activity today,",
            "stats": {
                "presence": 89,
                "completeness": 100,
                "assignments": 18,
                "totalSubjects": 12
            },
            "navigationItems": [
                {
                    "id": "course",
                    "title": "Course",
                    "icon": "book.closed",
                    "backgroundColor": "teal"
                },
                {
                    "id": "subjects",
                    "title": "Subjects",
                    "icon": "graduationcap",
                    "backgroundColor": "navy"
                },
                {
                    "id": "class",
                    "title": "Class",
                    "icon": "doc.text",
                    "backgroundColor": "orange"
                },
                {
                    "id": "presence",
                    "title": "Presence",
                    "icon": "checkmark",
                    "backgroundColor": "green"
                }
            ],
            "schedule": [
                {
                    "id": "economy",
                    "subject": "Economy",
                    "startHour": 7,
                    "duration": 2,
                    "color": "orange"
                },
                {
                    "id": "geography",
                    "subject": "Geography",
                    "startHour": 9,
                    "duration": 2,
                    "color": "cyan"
                },
                {
                    "id": "english",
                    "subject": "English",
                    "startHour": 11,
                    "duration": 2,
                    "color": "blue"
                }
            ]
        }
        """
        
        let data = mockJSON.data(using: .utf8)!
        return try! JSONDecoder().decode(StudentData.self, from: data)
    }
}

// MARK: - Main View
struct StudentDashboardView: View {
    @StateObject private var dataService = StudentDataService()
    
    var body: some View {
        NavigationView {
            Group {
                if dataService.isLoading {
                    LoadingView()
                } else if let studentData = dataService.studentData {
                    DashboardContentView(studentData: studentData)
                } else {
                    ErrorView()
                }
            }
        }
        .overlay(
            // Bottom Tab Bar
            VStack {
                Spacer()
                BottomTabBar()
            }
        )
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Error View
struct ErrorView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text("Failed to load data")
                .font(.headline)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Dashboard Content
struct DashboardContentView: View {
    let studentData: StudentData
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                DashboardHeader(
                    name: studentData.name,
                    greeting: studentData.greeting
                )
                
                // Stats Cards
                StatsCardsView(stats: studentData.stats)
                
                // Navigation Icons
                NavigationIconsView(items: studentData.navigationItems)
                
                // Schedule Section
                ScheduleView(classes: studentData.schedule)
                
                Spacer(minLength: 100)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Header
struct DashboardHeader: View {
    let name: String
    let greeting: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, \(name)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(greeting)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 25)
    }
}

// MARK: - Stats Cards
struct StatsCardsView: View {
    let stats: StudentStats
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                StatsCard(
                    value: "\(stats.presence)%",
                    title: "Presence",
                    valueColor: .orange
                )
                
                StatsCard(
                    value: "\(stats.completeness)%",
                    title: "Completeness",
                    valueColor: .blue
                )
            }
            
            HStack(spacing: 15) {
                StatsCard(
                    value: "\(stats.assignments)",
                    title: "Assignments",
                    valueColor: .cyan
                )
                
                StatsCard(
                    value: "\(stats.totalSubjects)",
                    title: "Total Subject",
                    valueColor: .orange
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

// MARK: - Navigation Icons
struct NavigationIconsView: View {
    let items: [NavigationItem]
    
    var body: some View {
        HStack(spacing: 25) {
            ForEach(items) { item in
                NavigationIconView(item: item)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

// MARK: - Schedule
struct ScheduleView: View {
    let classes: [ScheduleClass]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Schedule")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // Time Headers
            HStack {
                ForEach(7...12, id: \.self) { hour in
                    Text("\(hour)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            // Schedule Items
            VStack(spacing: 8) {
                ForEach(classes) { scheduleClass in
                    ScheduleItem(scheduleClass: scheduleClass)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Reusable Components
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

struct NavigationIconView: View {
    let item: NavigationItem
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {}) {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(colorFromString(item.backgroundColor))
                    .clipShape(Circle())
            }
            
            Text(item.title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
    
    private func colorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "orange": return .orange
        case "blue": return .blue
        case "green": return .green
        case "teal": return Color(red: 0.4, green: 0.6, blue: 0.7)
        case "navy": return Color(red: 0.2, green: 0.3, blue: 0.5)
        case "cyan": return .cyan
        default: return .gray
        }
    }
}

struct ScheduleItem: View {
    let scheduleClass: ScheduleClass
    
    var body: some View {
        HStack {
            ForEach(0..<6, id: \.self) { index in
                let hourIndex = index + 7
                let startColumn = scheduleClass.startHour - 7
                let endColumn = startColumn + scheduleClass.duration
                
                if hourIndex >= scheduleClass.startHour && hourIndex < scheduleClass.startHour + scheduleClass.duration {
                    if hourIndex == scheduleClass.startHour {
                        Text(scheduleClass.subject)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(colorFromString(scheduleClass.color).opacity(0.3))
                            .cornerRadius(6)
                    } else {
                        Rectangle()
                            .fill(colorFromString(scheduleClass.color).opacity(0.3))
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
    
    private func colorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "orange": return .orange
        case "blue": return .blue
        case "green": return .green
        case "cyan": return .cyan
        case "red": return .red
        case "purple": return .purple
        default: return .gray
        }
    }
}

struct BottomTabBar: View {
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(icon: "square.grid.2x2", isSelected: true)
            TabBarItem(icon: "calendar", isSelected: false)
            TabBarItem(icon: "list.bullet", isSelected: false)
            TabBarItem(icon: "person", isSelected: false)
        }
        .padding(.vertical, 15)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray.opacity(0.3)),
            alignment: .top
        )
    }
}

struct TabBarItem: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StudentDashboardView()
}