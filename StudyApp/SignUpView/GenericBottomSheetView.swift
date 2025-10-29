//
//  GenericBottomSheetView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 19/04/25.
//

import SwiftUI

// MARK: - Generic Data Protocol
protocol BottomSheetDisplayable: Identifiable, Hashable {
    var displayTitle: String? { get }
    var displaySubtitle: String? { get }
    var displayNote1: String? { get }
    var displayNote2: String? { get }
}

enum SelectionMode {
    case single
    case multiple
}

struct SelectableBottomSheet<T: BottomSheetDisplayable>: View {
    let title: String
    let items: [T]
    @Binding var selected: Set<T>
    let onClose: () -> Void
    let selectionMode: SelectionMode

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .foregroundColor(.green)
                        .padding(8)
                }
                Spacer()
                Text(title)
                    .font(.headline)
                    .textCase(.uppercase)
                Spacer()
                Color.clear.frame(width: 32)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
            
            Divider()
            
            List(items, id: \.id) { item in
                Button(action: {
                    switch selectionMode {
                    case .single:
                        if selected.contains(item) {
                            selected.remove(item)
                        } else {
                            selected = [item] // Only one item selected at a time
                        }
                    case .multiple:
                        if selected.contains(item) {
                            selected.remove(item)
                        } else {
                            selected.insert(item)
                        }
                    }
                })
                {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.displayTitle ?? "")
                                .foregroundColor(.primary)
                            if let subtitle = item.displaySubtitle, !subtitle.isEmpty {
                                Text(subtitle)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            if let note1 = item.displayNote1, !note1.isEmpty {
                                Text(note1)
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                            }
                            if let note2 = item.displayNote2, !note2.isEmpty {
                                Text(note2)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }

                        }
                        Spacer()
                        if selected.contains(item) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background {
                        Rectangle()
                            .foregroundStyle(selected.contains(item) ? Color.accentColor.opacity(0.1) : .clear)
                            .cornerRadius(18)
                    }
                }
            }
            .listRowSeparator(.hidden, edges: .all) // Hides all separators
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .cornerRadius(20)
        .background(Color.white)
    }
}

// MARK: - Example Usage

struct Portfolio: BottomSheetDisplayable {
    let id: UUID
    let displayTitle: String?
    var displaySubtitle: String?
    var displayNote1: String?
    var displayNote2: String?
}

#Preview {
    GenericBottomSheetView()
}

struct GenericBottomSheetView: View {
    @State private var showSheet = false
    @State private var selectedItems = Set<Portfolio>()
    @State private var selectionMode: SelectionMode = .multiple // Default to multiple selection
    
    let data = [
        Portfolio(id: UUID(), displayTitle: "1876-76765-19876", displaySubtitle: "Portfolio", displayNote1: "Sell Order", displayNote2: ""),
        Portfolio(id: UUID(), displayTitle: "1876-76765-19676", displaySubtitle: "Portfolio", displayNote1: "Sell Order", displayNote2: ""),
        Portfolio(id: UUID(), displayTitle: "1876-76765-37487", displaySubtitle: "", displayNote1: "Sell Order", displayNote2: ""),
    ]

    var body: some View {
        VStack(spacing: 20) {
            Picker("Selection Mode", selection: $selectionMode) {
                Text("Single").tag(SelectionMode.single)
                Text("Multiple").tag(SelectionMode.multiple)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Show Bottom Sheet") {
                showSheet = true
            }
        }
        .sheet(isPresented: $showSheet) {
            SelectableBottomSheet(
                title: "Select Portfolio",
                items: data,
                selected: $selectedItems,
                onClose: {
                    showSheet = false
                },
                selectionMode: selectionMode
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden) // Optional: hide handle gap
        }
    }
}
