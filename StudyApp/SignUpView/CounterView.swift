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
struct Settings: Hashable {
    let name: String
    let theme: String
    let showTutorial: Bool
    let favoriteColor: String
}

struct NavigationStackVw: View {
    @State private var path = NavigationPath()
    @State private var isOn: Bool = false
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
                .if(true) { view in
                    view.foregroundColor(.blue)
                }

                Button("Open Article") {
                    path.append(Article(title: "SwiftUI Tips"))
                }
                Button(action: {
                    path.append(Settings(name: "Karan", theme: "Light", showTutorial: true, favoriteColor: "Blue"))
                    // Navigate or perform action here
                }){
                    Label("Settings", systemImage: "gear")
                }            }
            .navigationDestination(for: Userr.self) { user in
                HStack(alignment: .lastTextBaseline) {
                    Text("SwiftUI")
                        .font(.callout)
                    Text("Shortcuts")
                }
                Text("User: \(user.name)")
                profileImage(isLoggedIn: true)
            }
            .navigationDestination(for: Article.self) { article in
                ZStack {
                    Color.cyan
                        .ignoresSafeArea()
                    VStack {
                        Text("Article: \(article.title)")
                        Group {
                            Text("Welcome")
                            Text("to SwiftUI")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationDestination(for: Settings.self) { settings in
                List {
                    Text("Name: \(settings.name)")
                    Text("Show Tutorial: \(settings.showTutorial)")
                    Text("Favourite Color: \(settings.favoriteColor)")
                    Text("Thene: \(settings.theme)")
                    Text(isOn ? "ON" : "OFF")
                        .padding()
                        .background(isOn ? .green : .red)
                        .animation(.spring, value: isOn)
                        .onTapGesture {
                            isOn.toggle()
                        }
                }
            }
        }
    }
    @ViewBuilder
    func profileImage(isLoggedIn: Bool) -> some View {
        if isLoggedIn {
            Image(systemName: "person.crop.circle.fill")
                .foregroundColor(.green)
                .dynamicTypeSize(.accessibility5)
        } else {
            Image(systemName: "person.crop.circle.badge.xmark")
                .foregroundColor(.red)
                .frame(width: 50, height: 50)
                .dynamicTypeSize(.accessibility1)
        }
    }
}

#Preview {
    NavigationStackVw()
}
