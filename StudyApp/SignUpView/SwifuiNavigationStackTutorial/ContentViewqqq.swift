//
//  ContentView.swift
//  SchoolStudentApp
//
//  Created by Rajesh Mani on 31/07/25.
// reference: https://swift-pal.com
import SwiftUI

struct ContentVieww: View {
    @State private var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Button("Go to Profile") {
                    navigationManager.navigate(to: .profile(userID: "user123"))
                }
                
                Button("Go to Settings") {
                    navigationManager.navigate(to: .settings)
                }
                
                Button("View Product") {
                    let product = Product(id: UUID(), name: "iPhone17", descriptionn: "Latest Arrival", price: 250)
                    navigationManager.navigate(to: .productDetail([product]))
                }
                Button("Order History") {
                    navigationManager.navigate(to: .orderHistory(userID: "user123", page: 5))
                }

            }
            .navigationDestination(for: AppDestination.self) { destination in
                destinationView(for: destination)
            }
        }
        .environment(navigationManager)
    }
    
    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
        case .profile(let userID):
            ProfileVu(userID: userID)
        case .settings:
            SettingsHomeView(img: .student3, router: Router<MainRoute>())
        case .cart:
            CartView()
        case .productDetail(let products):
            ProductDetailView(products: products)
        case .orderHistory(let userID, let page):
            OrderHistoryView(userID: userID, initialPage: page)
        case .dashboard:
            StudentDashboardView(router: Router<MainRoute>())
        default:
            EmptyView()
        }
    }
}

#Preview {
    ContentVieww()
}


struct ProfileVu: View {
    let userID: String

    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
            Text("User ID: \(userID)")
                .font(.subheadline)
        }
        .padding()
    }
}


struct SettingsView2: View {
    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Toggle("Enable Notifications", isOn: .constant(true))
                Toggle("Dark Mode", isOn: .constant(false))
            }
            Section {
                Button("Sign Out") { }
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
    }
}


struct CartView: View {
    var body: some View {
        VStack {
            Text("Your Cart")
                .font(.largeTitle)
            List {
                Text("Item 1")
                Text("Item 2")
            }
            Spacer()
            Button("Checkout") { }
                .padding()
        }
        .padding()
    }
}


struct ProductDetailView: View {
    let products: [Product]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(products, id: \.self) { product in
                    Text(product.name)
                        .font(.title)
                    
                    Text(product.descriptionn)
                        .font(.body)
                    Text("Price: $\(product.price, specifier: "%.2f")")
                        .bold()
                    Button("Add to Cart") { }
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Product Detail")
    }
}


struct OrderHistoryView: View {
    let userID: String
    let initialPage: Int

    var body: some View {
        VStack {
            Text("Order History")
                .font(.largeTitle)
            Text("User: \(userID), Page: \(initialPage)")
            List {
                ForEach(0..<10) { index in
                    Text("Order #\(initialPage * 10 + index + 1)")
                }
            }
        }
        .padding()
    }
}
