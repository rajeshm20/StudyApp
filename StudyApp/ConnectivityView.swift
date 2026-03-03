//
//  ConnectivityView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 28/12/25.
//

import SwiftUI
import Network

struct ConnectivityView: View {
    @State private var path: NWPath?
    @State private var monitor: NWPathMonitor?
    var body: some View {
        VStack {
            switch path?.status {
            case .satisfied:
                ContentUnavailableView("You are connected", systemImage: "wifi")
                    .background(.green)
            case .unsatisfied:
                ZStack {
                    ContentUnavailableView("Not connected", systemImage: "wifi.slash", description: Text(path?.unsatisfiedReason.hashValue.description ?? "Unknown error"))
                        .background(.red)
                    VStack {
                        Spacer()
                        Spacer()
                        Button("Refresh", action: {
                            refreshPath()
                        })
                        Spacer()
                    }   
                }
            case .requiresConnection:
                ContentUnavailableView("Connecting...", systemImage: "wifi.exclamationmark", description: Text(path?.unsatisfiedReason.hashValue.description ?? "Unknown error") )
                    .background(.red)
            default:
                ContentUnavailableView("Unknown...", systemImage: "wifi.exclamationmark", description: Text("We can't establish network Connection"))
                    .background(.red)
            }
        }
        .task {
            await startMonitor()
        }
        .ignoresSafeArea()
    }
}

private extension ConnectivityView {
    func startMonitor() async {
        for try await path in pathUpdatesStream() {
            self.path = path
        }
    }
    
    func stopMonitor() {
        monitor?.cancel()
        monitor = nil
    }
    
    func refreshPath() {
        Task { await startMonitor() }
    }
    
    func pathUpdatesStream() -> AsyncStream<NWPath> {
        AsyncStream { continuation in
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                continuation.yield(path)
            }
            monitor.start(queue: .global(qos: .background))
            continuation.onTermination = { _ in
                Task { @MainActor in
                    stopMonitor()
                }
            }
        }
    }
}
#Preview {
    ConnectivityView()
}
