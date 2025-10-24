import SwiftUI

struct StudentDashboardView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hi, Jenny Wilson")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Here is your activity today,")
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
                    
                    // Stats Cards
                    HStack(spacing: 15) {
                        StatsCard(
                            value: "89%",
                            title: "Presence",
                            valueColor: .orange
                        )
                        
                        StatsCard(
                            value: "100%",
                            title: "Completeness",
                            valueColor: .blue
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
                    
                    HStack(spacing: 15) {
                        StatsCard(
                            value: "18",
                            title: "Assignments",
                            valueColor: .cyan
                        )
                        
                        StatsCard(
                            value: "12",
                            title: "Total Subject",
                            valueColor: .orange
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    // Navigation Icons
                    HStack(spacing: 25) {
                        NavigationIconView(
                            icon: "book.closed",
                            title: "Course",
                            backgroundColor: Color(red: 0.4, green: 0.6, blue: 0.7)
                        )
                        
                        NavigationIconView(
                            icon: "graduationcap",
                            title: "Subjects",
                            backgroundColor: Color(red: 0.2, green: 0.3, blue: 0.5)
                        )
                        
                        NavigationIconView(
                            icon: "doc.text",
                            title: "Class",
                            backgroundColor: .orange
                        )
                        
                        NavigationIconView(
                            icon: "checkmark",
                            title: "Presence",
                            backgroundColor: .green
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    // Schedule Section
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
                            ScheduleItem(
                                subject: "Economy",
                                color: Color.orange.opacity(0.3),
                                startColumn: 0,
                                span: 2
                            )
                            
                            ScheduleItem(
                                subject: "Geography",
                                color: Color.cyan.opacity(0.3),
                                startColumn: 2,
                                span: 2
                            )
                            
                            ScheduleItem(
                                subject: "English",
                                color: Color.blue.opacity(0.3),
                                startColumn: 4,
                                span: 2
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .overlay(
            // Bottom Tab Bar
            VStack {
                Spacer()
                
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
        )
    }
}

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