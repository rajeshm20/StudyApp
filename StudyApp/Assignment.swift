import SwiftUI
import EventKit
import EventKitUI
import Foundation

// MARK: - Data Models
struct Assignment: Codable, Identifiable {
    let id: String
    let title: String
    let dueDate: String
    let status: AssignmentStatus
    let category: String
    let daysLeft: Int
    var eventIdentifier: String?
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

// MARK: - EventKit Manager
@MainActor
class EventKitManager: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var hasCalendarAccess = false
    @Published var events: [EKEvent] = []
    
    init() {
        requestCalendarAccess()
    }
    
    func requestCalendarAccess() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            hasCalendarAccess = true
            loadEvents()
        case .notDetermined:
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                DispatchQueue.main.async {
                    self?.hasCalendarAccess = granted
                    if granted {
                        self?.loadEvents()
                    }
                }
            }
        case .denied, .restricted:
            hasCalendarAccess = false
        @unknown default:
            hasCalendarAccess = false
        }
    }
    
    private func loadEvents() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .month, value: 1, to: startDate) ?? Date()
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        events = eventStore.events(matching: predicate)
    }
    
    func addAssignmentToCalendar(_ assignment: Assignment, completion: @escaping (Bool) -> Void) {
        guard hasCalendarAccess else {
            completion(false)
            return
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = assignment.title
        event.notes = "Assignment - \(assignment.category)"
        
        // Parse due date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let dueDate = dateFormatter.date(from: assignment.dueDate) {
            event.startDate = dueDate
            event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: dueDate) ?? dueDate
        }
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            completion(true)
        } catch {
            print("Failed to save event: \(error)")
            completion(false)
        }
    }
}

// MARK: - Data Manager
@MainActor
class AssignmentDataManager: ObservableObject {
    @Published var calendarData: CalendarData?
    @Published var isLoading = true
    @Published var selectedDate = Date()
    
    init() {
        Task {
            await loadMockData()
        }
    }
    
    func loadMockData() async {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        self.calendarData = self.getMockData()
        self.isLoading = false
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

// MARK: - Native iOS Calendar View
struct NativeCalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    let onDateSelected: (Date) -> Void
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.availableDateRange = DateInterval(start: .distantPast, end: .distantFuture)
        calendarView.fontDesign = .default
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        selection.selectedDate = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        calendarView.selectionBehavior = selection
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        if let selection = uiView.selectionBehavior as? UICalendarSelectionSingleDate {
            selection.selectedDate = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        let parent: NativeCalendarView
        
        init(_ parent: NativeCalendarView) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents = dateComponents,
                  let date = Calendar.current.date(from: dateComponents) else { return }
            
            parent.selectedDate = date
            parent.onDateSelected(date)
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            // Add decorations for dates with assignments
            return nil
        }
    }
}

// MARK: - Main View
struct AssignmentCalendarView: View {
    @StateObject private var dataManager = AssignmentDataManager()
    @StateObject private var eventKitManager = EventKitManager()
    @State private var showingEventController = false
    @State private var selectedAssignment: Assignment?
    
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
                    // Native iOS Calendar
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(DateFormatter.monthFormatter.string(from: dataManager.selectedDate))
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    let newDate = Calendar.current.date(byAdding: .month, value: -1, to: dataManager.selectedDate) ?? dataManager.selectedDate
                                    dataManager.selectedDate = newDate
                                }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.gray)
                                }
                                
                                Button(action: {
                                    let newDate = Calendar.current.date(byAdding: .month, value: 1, to: dataManager.selectedDate) ?? dataManager.selectedDate
                                    dataManager.selectedDate = newDate
                                }) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        // Native iOS Calendar View
                        NativeCalendarView(selectedDate: $dataManager.selectedDate) { date in
                            dataManager.selectedDate = date
                        }
                        .frame(height: 300)
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
                        
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(calendarData.assignments) { assignment in
                                    AssignmentRowView(
                                        assignment: assignment,
                                        onAddToCalendar: {
                                            selectedAssignment = assignment
                                            addToCalendar(assignment)
                                        }
                                    )
                                }
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
    
    private func addToCalendar(_ assignment: Assignment) {
        eventKitManager.addAssignmentToCalendar(assignment) { success in
            if success {
                // Show success feedback
                print("Assignment added to calendar successfully")
            } else {
                // Show error feedback
                print("Failed to add assignment to calendar")
            }
        }
    }
}

// MARK: - Assignment Row View
struct AssignmentRowView: View {
    let assignment: Assignment
    let onAddToCalendar: () -> Void
    
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
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(daysLeftText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(daysLeftColor)
                
                Button(action: onAddToCalendar) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                }
            }
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
            TabBarItemm(icon: "square.grid.2x2", isSelected: false)
            TabBarItemm(icon: "calendar", isSelected: true)
            TabBarItemm(icon: "doc.text", isSelected: false)
            TabBarItemm(icon: "person", isSelected: false)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .background(Color.white)
    }
}

// MARK: - Tab Bar Item
struct TabBarItemm: View {
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

// MARK: - Extensions
extension DateFormatter {
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}

// MARK: - Content View
struct AssignmentContentView: View {
    var body: some View {
        AssignmentCalendarView()
    }
}

#Preview {
    AssignmentContentView()
}
