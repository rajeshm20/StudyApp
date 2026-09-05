import SwiftUI

// MARK: - Tab Selection

enum TabSelection: String, CaseIterable {
    case dashboard = "Dashboard"
    case calendar = "Calendar"
    case assignments = "Assignments"
    case profile = "Profile"

    var icon: String {
        switch self {
        case .dashboard: "square.grid.2x2"
        case .calendar: "calendar"
        case .assignments: "list.bullet"
        case .profile: "person"
        }
    }
}

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

@MainActor
class StudentDataService: ObservableObject {
    @Published var studentData: StudentData?
    @Published var isLoading = true

    init() {
        Task {
            await loadMockData()
        }
    }

    private func loadMockData() async {
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        studentData = getMockStudentData()
        isLoading = false
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
    @State private var selectedTab: TabSelection = .dashboard
    @EnvironmentObject var popupManager: PopupManager
    @EnvironmentObject private var localizationService: LocalizationService
    var router: Router<MainRoute>
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Main Content
                Group {
                    switch selectedTab {
                    case .dashboard:
                        if dataService.isLoading {
                            LoadingView()
                        } else if let studentData = dataService.studentData {
                            DashboardContentView(studentData: studentData, router: router)
                        } else {
                            ErrorView()
                        }
                    case .calendar:
                        AssignmentContainerView(router: router)
                    case .assignments:
                        AssignmentsView()
                    case .profile:
                        SettingsHomeView(router: router)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                BottomTabBar(selectedTab: $selectedTab)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Loading View

struct LoadingView: View {
    @EnvironmentObject private var localizationService: LocalizationService

    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text(localizationService.text(.dashboardLoading))
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
    @EnvironmentObject private var localizationService: LocalizationService

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text(localizationService.text(.dashboardFailedToLoad))
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
    var router: Router<MainRoute>

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
                NavigationIconsView(items: studentData.navigationItems, router: router)

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
    @EnvironmentObject private var localizationService: LocalizationService
    let name: String
    let greeting: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(localizationService.text(.dashboardGreeting, name))
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
    @EnvironmentObject private var localizationService: LocalizationService
    let stats: StudentStats

    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                StatsCard(
                    value: "\(stats.presence)%",
                    title: localizationService.text(.dashboardPresence),
                    valueColor: .orange
                )

                StatsCard(
                    value: "\(stats.completeness)%",
                    title: localizationService.text(.dashboardCompleteness),
                    valueColor: .blue
                )
            }

            HStack(spacing: 15) {
                StatsCard(
                    value: "\(stats.assignments)",
                    title: localizationService.text(.dashboardAssignments),
                    valueColor: .cyan
                )

                StatsCard(
                    value: "\(stats.totalSubjects)",
                    title: localizationService.text(.dashboardTotalSubjects),
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
    var router: Router<MainRoute>

    var body: some View {
        HStack(spacing: 40) {
            ForEach(items) { item in
                NavigationIconView(item: item, router: router)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

// MARK: - Schedule

struct ScheduleView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    let classes: [ScheduleClass]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(localizationService.text(.dashboardSchedule))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding(.horizontal, 20)

            // Time Headers
            HStack {
                ForEach(7 ... 12, id: \.self) { hour in
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

// MARK: - Tab Views

struct CalendarView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Calendar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Mock Calendar Events
                VStack(spacing: 15) {
                    CalendarEventCard(
                        title: "Economics Final Exam",
                        date: "Sept 15, 2025",
                        time: "9:00 AM - 11:00 AM",
                        color: .orange
                    )

                    CalendarEventCard(
                        title: "Geography Project Due",
                        date: "Sept 18, 2025",
                        time: "11:59 PM",
                        color: .cyan
                    )

                    CalendarEventCard(
                        title: "English Literature Quiz",
                        date: "Sept 20, 2025",
                        time: "10:00 AM - 10:30 AM",
                        color: .blue
                    )
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationTitle("Calendar")
        .background(Color(.systemGroupedBackground))
    }
}

struct AssignmentsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Assignments")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Text("18 Total")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Assignment Categories
                VStack(spacing: 15) {
                    AssignmentCard(
                        title: "Pending Assignments",
                        count: "5",
                        color: .orange,
                        assignments: ["Economic Analysis Report", "Geography Map Project", "English Essay Draft"]
                    )

                    AssignmentCard(
                        title: "Completed Assignments",
                        count: "13",
                        color: .green,
                        assignments: ["Math Problem Set", "History Timeline", "Science Lab Report"]
                    )
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationTitle("Assignments")
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Helper Views

struct CalendarEventCard: View {
    let title: String
    let date: String
    let time: String
    let color: Color

    var body: some View {
        HStack {
            Rectangle()
                .fill(color)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct AssignmentCard: View {
    let title: String
    let count: String
    let color: Color
    let assignments: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Text(count)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 6) {
                ForEach(assignments.prefix(3), id: \.self) { assignment in
                    HStack {
                        Circle()
                            .fill(color.opacity(0.3))
                            .frame(width: 6, height: 6)

                        Text(assignment)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ProfileStatView: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Reusable Components

struct StatsCard: View {
    let value: String
    let title: String
    let valueColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(valueColor)

            Text(title)
                .font(.title3)
                .foregroundColor(.black.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .frame(width: 150, height: 100)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct NavigationIconView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    let item: NavigationItem
    var router: Router<MainRoute>

    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                switch localizedTitle {
                case localizationService.text(.dashboardCourse):
                    router.push(.courses)
                case localizationService.text(.dashboardSubjects):
                    router.push(.courseDetails)
                case localizationService.text(.dashboardClass):
                    router.push(.myClasses)
                case localizationService.text(.dashboardPresence):
                    router.push(.myPresence)
                default:
                    break
                }
            }) {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(colorFromString(item.backgroundColor))
                    .clipShape(Circle())
            }

            Text(localizedTitle)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }

    private var localizedTitle: String {
        switch item.title {
        case "Course":
            localizationService.text(.dashboardCourse)
        case "Subjects":
            localizationService.text(.dashboardSubjects)
        case "Class":
            localizationService.text(.dashboardClass)
        case "Presence":
            localizationService.text(.dashboardPresence)
        default:
            item.title
        }
    }

    private func colorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "orange": .orange
        case "blue": .blue
        case "green": .green
        case "teal": Color(red: 0.4, green: 0.6, blue: 0.7)
        case "navy": Color(red: 0.2, green: 0.3, blue: 0.5)
        case "cyan": .cyan
        default: .gray
        }
    }
}

struct ScheduleItem: View {
    let scheduleClass: ScheduleClass

    var body: some View {
        HStack(spacing: 0) {
            // Calculate positioning
            let startColumn = scheduleClass.startHour - 7
            let totalColumns = 6

            // Add spacers before the class block
            ForEach(0 ..< startColumn, id: \.self) { _ in
                Spacer()
                    .frame(maxWidth: .infinity)
            }

            // Class block spanning multiple columns
            HStack(spacing: 0) {
                Text(scheduleClass.subject)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                Spacer()
            }
            .frame(height: 32)
            .frame(maxWidth: .infinity)
            .frame(width: CGFloat(scheduleClass.duration) * (UIScreen.main.bounds.width - 40) / CGFloat(totalColumns))
            .background(colorFromString(scheduleClass.color).opacity(0.3))
            .cornerRadius(6)

            // Add spacers after the class block
            let remainingColumns = totalColumns - startColumn - scheduleClass.duration
            ForEach(0 ..< remainingColumns, id: \.self) { _ in
                Spacer()
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func colorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "orange": .orange
        case "blue": .blue
        case "green": .green
        case "cyan": .cyan
        case "red": .red
        case "purple": .purple
        default: .gray
        }
    }
}

struct BottomTabBar: View {
    @Binding var selectedTab: TabSelection

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabSelection.allCases, id: \.self) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
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
    let tab: TabSelection
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: tab.icon)
                .font(.title2)
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Dashboard") {
    StudentDashboardView(router: Router<MainRoute>())
        .environmentObject(PopupManager())
}
