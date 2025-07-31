//
//  CounterView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 26/06/25.
//

import SwiftUI
//
//struct CounterView: View {
//    let store: StoreOf<CounterFeature>
//
//    var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            VStack {
//                Text("\(viewStore.count)")
//                HStack {
//                    Button("-") { viewStore.send(.decrementButtonTapped) }
//                    Button("+") { viewStore.send(.incrementButtonTapped) }
//                }
//                Button("Get Fact") { viewStore.send(.numberFactButtonTapped) }
//                if let fact = viewStore.numberFact {
//                    Text(fact)
//                }
//            }
//        }
//    }
//}
//class Usr {
//    var name = "Anonymous"
//}
//
//struct ContentVieww: View {
//    var body: some View {
//        Text("Hello, world!")
//            .task {
//                let user = Usr()
//                await loadData(for: user)
//            }
//    }
//
//    func loadData(for user: Usr) async {
//        print("Loading data for \(user.name)…")
//    }
//}
struct Userr: Hashable { let name: String }
struct Article: Hashable { let title: String }

struct NavigationStackVw: View {
    @State private var path = NavigationPath()
    var body: some View {
//        NavigationStack {
//            List {
//                NavigationLink("Go to Detail", value: "SwiftUI ❤️ NavigationStack")
//            }
//            .navigationDestination(for: String.self) { value in
//                Text("You selected: \(value)")
//            }
//            .navigationTitle("Home")
//        }

        NavigationStack(path: $path) {
            List {
                Button("Open User") {
                    path.append(Userr(name: "Karan"))
                }
                Button("Open Article") {
                    path.append(Article(title: "SwiftUI Tips"))
                }
            }
            .navigationDestination(for: Userr.self) { user in
                Text("User: \(user.name)")
            }
            .navigationDestination(for: Article.self) { article in
                Text("Article: \(article.title)")
            }
        }
    }
}

#Preview {
    NavigationStackVw()
}


